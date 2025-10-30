FROM node:18-alpine AS builder
WORKDIR /app

# Copy package files and install
COPY package*.json ./
RUN npm ci --production

# Copy source
COPY . .

# Build step if the app needs it (uncomment if you have a build step)
# RUN npm run build

# Run stage
FROM node:18-alpine
WORKDIR /app

# Copy node modules and app
COPY --from=builder /app .

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server.js"]
