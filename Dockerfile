# ใช้ Node.js image เป็น image พื้นฐาน
# bullseye-slim เป็นเวอร์ชันที่เล็ก แต่ยังคงมีเครื่องมือที่จำเป็นครบ
FROM node:18-bullseye-slim

# กำหนด Working Directory ภายใน Container
WORKDIR /usr/src/app

# ติดตั้ง Dependencies ที่ Puppeteer ต้องการสำหรับรัน Chrome แบบ Headless
# อ้างอิงจากเอกสารของ Puppeteer
RUN apt-get update     && apt-get install -yq --no-install-recommends     ca-certificates     fonts-liberation     libappindicator3-1     libasound2     libatk-bridge2.0-0     libatk1.0-0     libcairo2     libcups2     libdbus-1-3     libexpat1     libfontconfig1     libgbm1     libgcc1     libglib2.0-0     libgtk-3-0     libnspr4     libnss3     libpango-1.0-0     libpangocairo-1.0-0     libstdc++6     libx11-6     libx11-xcb1     libxcb1     libxcomposite1     libxcursor1     libxdamage1     libxext6     libxfixes3     libxi6     libxrandr2     libxrender1     libxss1     libxtst6     lsb-release     wget     xdg-utils     --fix-missing

# คัดลอกไฟล์ package.json และ package-lock.json
COPY package*.json ./

# ติดตั้ง Dependencies ของโปรเจค
# ใช้ --production เพื่อไม่ติดตั้ง devDependencies
RUN npm install --production

# คัดลอกโค้ดทั้งหมดของโปรเจคเข้ามาใน container
COPY . .

# Render จะใช้ PORT ที่กำหนดใน Environment Variable
# เราไม่จำเป็นต้อง EXPOSE port เอง
ENV NODE_ENV=production

# คำสั่งสำหรับรันแอปพลิเคชัน
CMD [ "node", "index.js" ]
