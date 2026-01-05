import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';
import { mps, mpAssistants } from '../drizzle/schema';
import { sql } from 'drizzle-orm';
import fs from 'fs';

async function importAssistants() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error('DATABASE_URL environment variable is required');
  }

  // Use a more robust connection configuration
  const client = postgres(connectionString, {
    connect_timeout: 30,
    idle_timeout: 20,
    max_lifetime: 60 * 30,
  });
  const db = drizzle(client);

  console.log('Reading scraped assistants data...');
  const assistantsData = JSON.parse(fs.readFileSync('mp_assistants.json', 'utf8'));

  console.log(`Found ${assistantsData.length} assistants. Fetching MP mapping...`);

  // Pre-fetch all MPs to avoid repeated queries over the tunnel
  const allMps = await db.select().from(mps);
  const mpMap = new Map(allMps.map(m => [m.name, m.id]));

  console.log(`Mapped ${mpMap.size} MPs. Starting batch import...`);

  const batchSize = 20;
  let count = 0;

  for (let i = 0; i < assistantsData.length; i += batchSize) {
    const batch = assistantsData.slice(i, i + batchSize);
    const valuesToInsert = batch
      .map(a => {
        const mpId = mpMap.get(a.mpName);
        if (!mpId) {
          console.warn(`MP not found: ${a.mpName}`);
          return null;
        }
        return {
          mpId,
          name: a.name,
          role: a.role,
          phone: a.phone,
          email: a.email,
        };
      })
      .filter(v => v !== null);

    if (valuesToInsert.length > 0) {
      try {
        await db.insert(mpAssistants).values(valuesToInsert);
        count += valuesToInsert.length;
        console.log(`Imported batch ${Math.floor(i / batchSize) + 1} (${count}/${assistantsData.length})`);
      } catch (error) {
        console.error(`Error importing batch starting at ${i}:`, error);
        // Try individual inserts for this batch if batch fails
        for (const val of valuesToInsert) {
          try {
            await db.insert(mpAssistants).values(val);
            count++;
          } catch (innerError) {
            console.error(`Failed individual insert for ${val.name}:`, innerError);
          }
        }
      }
    }
  }

  console.log(`✓ Assistants import completed. Imported ${count} assistants.`);
  await client.end();
  process.exit(0);
}

importAssistants().catch(err => {
  console.error('Import failed:', err);
  process.exit(1);
});
