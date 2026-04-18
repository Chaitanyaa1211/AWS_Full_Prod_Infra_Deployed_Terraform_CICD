FROM node:18-alpine

WORKDIR /app

# Copy only package files first (for caching)
COPY app/simple-node-app/package*.json ./

# Install dependencies
RUN npm install

# Copy remaining app files
COPY app/simple-node-app/ .

EXPOSE 3000

CMD ["node", "app.js"]
