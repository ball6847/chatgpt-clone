FROM node:18-slim as builder
COPY package.json package-lock.json ./
COPY server/package.json server/package-lock.json ./server/
RUN npm ci && cd server && npm ci
COPY . .
RUN npm run build

FROM node:18-slim as final
ENV NODE_ENV=production
ENV PORT=3000
WORKDIR /app
COPY server/ .
COPY --from=builder server/node_modules ./node_modules
COPY --from=builder build ./build
RUN sh -c "test -f .env && rm .env || true" && \
	sh -c "test -f .env.production.local && rm .env.production.local || true"

EXPOSE 3000
CMD ["npm", "run", "start"]
