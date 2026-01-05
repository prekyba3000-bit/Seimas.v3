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

  const client = postgres(connectionString);
  const db = drizzle(client);

  console.log('Reading scraped assistants data...');
  const assistantsData = JSON.parse(fs.readFileSync('mp_assistants.json', 'utf8'));

  console.log(`Found ${assistantsData.length} assistants. Starting import...`);

  let count = 0;
  for (const assistant of assistantsData) {
    try {
      // Find the MP by name
      const [dbMp] = await db.select().from(mps).where(sql`name = ${assistant.mpName}`);
      
      if (dbMp) {
        await db.insert(mpAssistants).values({
          mpId: dbMp.id,
          name: assistant.name,
          role: assistant.role,
          phone: assistant.phone,
          email: assistant.email,
        });
        count++;
      } else {
        console.warn(`MP not found for assistant: ${assistant.name} (MP: ${assistant.mpName})`);
      }
    } catch (error) {
      console.error(`Error importing assistant ${assistant.name}:`, error);
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
