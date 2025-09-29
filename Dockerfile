FROM node:20-alpine AS deps
WORKDIR /app
# your package files live in src/, so copy just those to enable layer cache
COPY src/package*.json ./
# use ci for reproducible, faster, cached installs
RUN npm ci --omit=dev

FROM node:20-alpine
WORKDIR /app
# bring in node_modules from the deps stage
COPY --from=deps /app/node_modules ./node_modules
# now copy the rest of your app
COPY src/ ./

EXPOSE 3000
CMD ["node", "app.js"]
