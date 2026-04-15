# ─── Stage 1: Builder ─────────────────────────────────
FROM oven/bun:1 AS builder
WORKDIR /app

# Install semua deps (termasuk devDeps untuk build)
COPY package.json bun.lockb* ./
RUN bun install --frozen-lockfile

COPY tsconfig.json ./
COPY src ./src

RUN bun build src/index.ts \
    --outdir dist \
    --target bun \
    --external puppeteer \
    --external sharp \
    --external whatsapp-web.js

# Install ulang hanya production deps
RUN bun install --frozen-lockfile --production

# ─── Stage 2: Production ──────────────────────────────
FROM oven/bun:1-slim AS runner
WORKDIR /app

RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
# ENV NODE_ENV=production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules 
COPY --from=builder /app/package.json ./

EXPOSE ${PORT:-2991}
CMD ["bun", "run", "dist/index.js"]