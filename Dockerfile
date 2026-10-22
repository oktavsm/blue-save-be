FROM node:22-bookworm-slim

WORKDIR /app

# Nilai sementara agar Prisma Client dapat dibuat saat proses build.
# Nilai ini akan ditimpa oleh environment dari Docker Compose saat runtime.
ENV DB_HOST=localhost \
    DB_PORT=3306 \
    DB_USER=placeholder \
    DB_PASSWORD=placeholder \
    DB_NAME=placeholder

RUN apt-get update -y && apt-get install -y openssl

COPY package.json package-lock.json ./
RUN npm ci

COPY tsconfig.json prisma.config.ts ./
COPY prisma ./prisma
COPY src ./src
COPY public ./public

RUN npx prisma generate
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
