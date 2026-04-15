# ─── Stage 1: Builder ─────────────────────────────────
FROM oven/bun:latest AS builder
WORKDIR /app

COPY package.json bun.lockb* ./
RUN bun install --frozen-lockfile

COPY tsconfig.json ./
COPY src ./src

RUN bun run build

# ─── Stage 2: Production ──────────────────────────────
FROM oven/bun:latest AS runner
WORKDIR /app

RUN apt-get update && apt-get install -y \
    chromium \
    ffmpeg \
    fonts-freefont-ttf \
    curl \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV NODE_ENV=production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

EXPOSE ${PORT:-2991}

CMD ["bun", "run", "dist/index.js"]