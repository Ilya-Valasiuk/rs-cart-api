FROM node:15.3.0-alpine3.10 as base

WORKDIR /usr/src/build

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:15.3.0-alpine3.10 as application

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY --from=base /usr/src/build/dist ./dist

RUN find dist | grep -E '.d.ts|.js.map|..tsbuildinfo' | xargs rm -rf 

EXPOSE 8080

CMD ["node", "dist/main.js"]