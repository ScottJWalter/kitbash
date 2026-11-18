FROM node:22-alpine AS build

WORKDIR /app
COPY package*.json tsconfig.json ./
COPY src ./src
RUN npm ci && npm run build

FROM node:22-alpine

ENV NODE_ENV=production \
    PORT=3000
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts
COPY --from=build /app/build ./build

EXPOSE 3000
CMD ["node", "build/index.js", "--http"]
