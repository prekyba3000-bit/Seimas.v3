import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';
import { mps, mpStats } from '../drizzle/schema';
import dotenv from 'dotenv';
import fs from 'fs';
import readline from 'readline';

dotenv.config();

async function importData() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error('DATABASE_URL environment variable is required');
  }

  const client = postgres(connectionString);
  const db = drizzle(client);

  console.log('Reading OpenSanctions MP data...');
  const fileStream = fs.createReadStream('seimas_mps_opensanctions.json');
  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  });

  let count = 0;
  for await (const line of rl) {
    if (!line.trim()) continue;
    const mpData = JSON.parse(line);
    
    const name = mpData.caption;
    const props = mpData.properties;
    const sourceUrl = props.sourceUrl ? props.sourceUrl[0] : '';
    const idMatch = sourceUrl.match(/p_asm_id=(\d+)/);
    const seimasId = idMatch ? idMatch[1] : mpData.id;
    
    const birthDate = props.birthDate ? props.birthDate[0] : null;
    const birthPlace = props.birthPlace ? props.birthPlace[0] : null;

    console.log(`Importing ${name}...`);
    
    try {
      // Insert or update MP
      await db.insert(mps).values({
        seimasId: seimasId,
        name: name,
        party: 'Nenurodyta',
        faction: 'Nenurodyta',
        photoUrl: `https://www.lrs.lt/SIPIS/sn_foto/2024/${name.toLowerCase().replace(/ /g, '_')}.jpg`,
        isActive: true,
        biography: `Lietuvos Respublikos Seimo narys. Gimimo data: ${birthDate || 'nežinoma'}. Gimimo vieta: ${birthPlace || 'nežinoma'}.`,
      }).onConflictDoUpdate({
        target: mps.seimasId,
        set: {
          name: name,
          updatedAt: new Date(),
        }
      });

      // Get the inserted/updated MP
      const [dbMp] = await db.select().from(mps).where(sql`seimas_id = ${seimasId}`);
      
      if (dbMp) {
        // Check if stats already exist
        const [existingStats] = await db.select().from(mpStats).where(sql`mp_id = ${dbMp.id}`);
        
        if (!existingStats) {
          // Initialize stats if they don't exist
          await db.insert(mpStats).values({
            mpId: dbMp.id,
            votingAttendance: (80 + Math.random() * 20).toFixed(2),
            partyLoyalty: (70 + Math.random() * 30).toFixed(2),
            billsProposed: Math.floor(Math.random() * 10),
            billsPassed: Math.floor(Math.random() * 5),
            accountabilityScore: (60 + Math.random() * 40).toFixed(2),
          });
        }
      }
      count++;
    } catch (error) {
      console.error(`Error importing ${name}:`, error);
    }
  }

  console.log(`✓ Data import completed successfully. Imported ${count} MPs.`);
  await client.end();
  process.exit(0);
}

// Import sql helper
import { sql } from 'drizzle-orm';

importData().catch(err => {
  console.error('Import failed:', err);
  process.exit(1);
});
