FROM node:18-slim as builder
COPY package.json package-lock.json ./
COPY server/package.json server/package-lock.json ./server/
RUN npm ci && cd server && npm ci
COPY . .
RUN npm run build

FROM node:18-slim as final
ENV NODE_ENV=production
WORKDIR /app
COPY server/ .
COPY --from=builder server/node_modules ./node_modules
COPY --from=builder build ./build

EXPOSE 3000
CMD ["npm", "run", "start"]
