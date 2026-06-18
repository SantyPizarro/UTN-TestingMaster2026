const { chromium } = require('@playwright/test');
const fs = require('fs');
const path = require('path');

async function run() {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('https://miel.unlam.edu.ar/');
  
  // Wait for the body to be loaded
  await page.waitForSelector('body');
  
  const bodyHtml = await page.evaluate(() => document.body.outerHTML);
  const title = await page.title();
  
  console.log('Title:', title);
  
  const outputPath = path.join(__dirname, 'miel_body.html');
  fs.writeFileSync(outputPath, bodyHtml, 'utf8');
  console.log('Saved HTML to:', outputPath);
  
  await browser.close();
}

run().catch(console.error);
