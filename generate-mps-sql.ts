import fs from 'fs';
import readline from 'readline';

async function generateSql() {
  const fileStream = fs.createReadStream('seimas_mps_opensanctions.json');
  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  });

  let sql = '-- Seimas MPs Data Import\n';
  sql += 'INSERT INTO mps (seimas_id, name, party, faction, district, photo_url, biography, is_active) VALUES\n';
  
  const values = [];

  for await (const line of rl) {
    const mp = JSON.parse(line);
    const seimasId = mp.properties.sourceUrl?.[0]?.split('p_asm_id=')[1] || mp.id;
    const name = mp.caption.replace(/'/g, "''");
    const party = 'Nepriklausomas'; // Default as OpenSanctions doesn't always have party
    const photoUrl = `https://www.lrs.lt/sip/portal.show?p_r=35299&p_k=1&p_a=498&p_asm_id=${seimasId}&p_img=1`;
    const biography = `Gimimo data: ${mp.properties.birthDate?.[0] || 'Nėra duomenų'}. Gimimo vieta: ${mp.properties.birthPlace?.[0] || 'Nėra duomenų'}.`;
    
    values.push(`('${seimasId}', '${name}', '${party}', NULL, NULL, '${photoUrl}', '${biography.replace(/'/g, "''")}', true)`);
  }

  sql += values.join(',\n') + '\nON CONFLICT (seimas_id) DO UPDATE SET name = EXCLUDED.name, photo_url = EXCLUDED.photo_url, biography = EXCLUDED.biography;';

  fs.writeFileSync('mps_data.sql', sql);
  console.log('✓ mps_data.sql generated successfully.');
}

generateSql();
