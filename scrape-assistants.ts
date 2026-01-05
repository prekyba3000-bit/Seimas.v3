import { chromium } from 'playwright';
import fs from 'fs';

async function scrapeAssistants() {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  console.log('Navigating to assistants page...');
  await page.goto('https://www.lrs.lt/sip/portal.show?p_r=35381&p_k=1&p_a=31&p_asm_id=47220');
  
  const mpOptions = await page.evaluate(() => {
    const select = document.querySelector('select');
    if (!select) return [];
    return Array.from(select.options)
      .slice(1)
      .map(opt => ({ name: opt.text, id: opt.value }));
  });

  console.log(`Found ${mpOptions.length} MPs. Starting extraction...`);
  
  const allAssistants = [];

  for (let i = 0; i < mpOptions.length; i++) {
    const mp = mpOptions[i];
    console.log(`[${i+1}/${mpOptions.length}] Extracting assistants for ${mp.name}...`);
    
    try {
      await page.selectOption('select', mp.id);
      // Wait for the table to update. The page might not reload but the content changes.
      // We'll wait for the name in the header to change or a short timeout.
      await page.waitForTimeout(1500); 
      
      const assistants = await page.evaluate((mpName) => {
        const rows = Array.from(document.querySelectorAll('table tr')).slice(1); // Skip header
        return rows.map(row => {
          const cells = row.querySelectorAll('td');
          if (cells.length < 4) return null;
          return {
            mpName: mpName,
            name: cells[0].innerText.trim(),
            role: cells[1].innerText.trim(),
            phone: cells[2].innerText.trim(),
            email: cells[3].innerText.trim()
          };
        }).filter(a => a !== null);
      }, mp.name);
      
      allAssistants.push(...assistants);
    } catch (err) {
      console.error(`Failed to extract for ${mp.name}:`, err);
    }
  }

  fs.writeFileSync('mp_assistants.json', JSON.stringify(allAssistants, null, 2));
  console.log(`✓ Extraction complete. Saved ${allAssistants.length} assistants to mp_assistants.json`);
  
  await browser.close();
}

scrapeAssistants();
