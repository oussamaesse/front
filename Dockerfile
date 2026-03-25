# Build stage
# switched from bun to npm/node for package management
FROM node:20-alpine AS builder

WORKDIR /app

# copy npm manifest and lockfile
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN mkdir -p public
RUN npm run build

# Runner stage - Next.js standalone uses Node.js
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

CMD ["node", "server.js"]