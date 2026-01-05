import { drizzle } from 'drizzle-orm/mysql2';
import { mps, mpStats } from '../drizzle/schema';
import dotenv from 'dotenv';
import axios from 'axios';
import { XMLParser } from 'fast-xml-parser';

dotenv.config();

import mysql from 'mysql2/promise';
const connection = await mysql.createConnection(process.env.DATABASE_URL!);
const db = drizzle(connection);
const parser = new XMLParser({
  ignoreAttributes: false,
  attributeNamePrefix: "@_",
});

async function syncMps() {
  console.log('Fetching MPs from Seimas API...');
  try {
    // Current term (kadencija) ID is usually the latest one. 
    // Based on the website, we can try to fetch the current members.
    const response = await axios.get('https://apps.lrs.lt/sip/p2b.ad_seimo_nariai');
    const result = parser.parse(response.data);
    
    // The structure usually looks like: SeimoNariai -> SeimoNarys
    const seimoNariai = result.SeimoNariai?.SeimoNarys;
    
    if (!seimoNariai || !Array.isArray(seimoNariai)) {
      console.error('Unexpected API response structure:', result);
      return;
    }

    console.log(`Found ${seimoNariai.length} MPs. Syncing to database...`);

    for (const sn of seimoNariai) {
      const seimasId = sn['@_asmens_id'] || sn.asmens_id;
      const name = `${sn.vardas} ${sn.pavarde}`;
      const party = sn.iskeltas_partijos || 'Išsikėlęs pats';
      const faction = sn.frakcija || 'Be frakcijos';
      const district = sn.apygarda || 'Daugiamandatė';
      const districtNumber = sn.apygardos_nr ? parseInt(sn.apygardos_nr) : null;
      
      // Construct photo URL - Seimas usually has a pattern for this
      // Pattern: https://www.lrs.lt/sip/portal.show?p_r=35299&p_k=1&p_a=seimo_narys&p_asm_id=[ID]
      // But for direct image, it's often different. We'll use a placeholder or try to find the real one.
      const photoUrl = `https://www.lrs.lt/sip/portal.show?p_r=35299&p_k=1&p_a=seimo_narys&p_asm_id=${seimasId}`;

      await db.insert(mps).values({
        seimasId: seimasId.toString(),
        name,
        party,
        faction,
        district,
        districtNumber,
        email: sn.el_pastas || `${sn.vardas.toLowerCase()}.${sn.pavarde.toLowerCase()}@lrs.lt`,
        phone: sn.telefonas || '',
        photoUrl,
        biography: `Lietuvos Respublikos Seimo narys.`,
        isActive: true,
      }).onDuplicateKeyUpdate({
        set: {
          name,
          party,
          faction,
          district,
          districtNumber,
          updatedAt: new Date(),
        }
      });
    }

    console.log('✓ MPs synced successfully.');

    // Initialize stats for new MPs if they don't exist
    const allMps = await db.select().from(mps);
    for (const mp of allMps) {
      const existingStats = await db.select().from(mpStats).where(sql`mp_id = ${mp.id}`);
      if (existingStats.length === 0) {
        await db.insert(mpStats).values({
          mpId: mp.id,
          votingAttendance: "0.00",
          partyLoyalty: "0.00",
          billsProposed: 0,
          billsPassed: 0,
          accountabilityScore: "0.00",
        });
      }
    }
    
  } catch (error) {
    console.error('Error syncing MPs:', error);
  }
}

// Helper for SQL queries in drizzle
import { sql } from 'drizzle-orm';

async function main() {
  await syncMps();
  console.log('Data synchronization finished.');
  process.exit(0);
}

main();
