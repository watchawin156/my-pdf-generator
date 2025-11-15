const express = require('express');
const puppeteer = require('puppeteer');

const app = express();
// Render.com จะกำหนด PORT มาให้ใน environment variable
const PORT = process.env.PORT || 3000;

// Endpoint หลักสำหรับทดสอบว่า API ทำงานอยู่
app.get('/', (req, res) => {
    res.send('PDF Generation API is running. Use /pdf?url=https://example.com');
});

// Endpoint สำหรับสร้าง PDF
app.get('/pdf', async (req, res) => {
    const { url } = req.query;

    if (!url) {
        return res.status(400).send('Please provide a URL. Usage: /pdf?url=https://example.com');
    }

    let browser;
    try {
        // การตั้งค่า puppeteer สำหรับ deploy บน Render.com หรือสภาพแวดล้อมแบบ Docker
        browser = await puppeteer.launch({
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--single-process'
            ],
            headless: 'new' // ใช้ 'new' สำหรับ headless mode ใหม่
        });

        const page = await browser.newPage();
        // ไปยัง URL ที่ต้องการ และรอให้โหลดเสร็จสมบูรณ์
        await page.goto(url, { waitUntil: 'networkidle0' });
        
        // สร้างไฟล์ PDF
        const pdf = await page.pdf({ format: 'A4', printBackground: true });

        // ส่งไฟล์ PDF กลับไป
        res.contentType('application/pdf');
        res.send(pdf);
    } catch (error) {
        console.error('Error generating PDF:', error);
        res.status(500).send('An error occurred while generating the PDF.');
    } finally {
        if (browser) {
            await browser.close();
        }
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
