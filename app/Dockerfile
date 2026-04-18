FROM node:18-alpine


WORKDIR /app
COPY simple-node-app/ .

RUN npm install

EXPOSE 3000

CMD ["node", "app.js"]
