# build stage
FROM public.ecr.aws/docker/library/node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# RUN npm run build
# production stage — serve built assets with lightweight server
FROM public.ecr.aws/docker/library/node:18-alpine
WORKDIR /app
# install serve or use a minimal static server; here using serve
RUN npm i -g serve
COPY --from=builder /app/dist ./dist
ENV PORT=3000
EXPOSE 3000
CMD ["sh", "-c", "serve -s dist -l 3000"]
