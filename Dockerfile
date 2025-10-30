# Stage 1 — Build React app
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2 — Serve app via Nginx
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

# Change default port to 3000
RUN sed -i 's/80/3000/g' /etc/nginx/conf.d/default.conf

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
