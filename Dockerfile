# Stage 1 — Build React app
FROM public.ecr.aws/docker/library/node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2 — Serve using Nginx
FROM public.ecr.aws/docker/library/nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
