# ---- Builder Stage ----
FROM node:20-alpine AS builder

WORKDIR /app

# Install git
RUN apk add --no-cache git

# Clone the repository
RUN git clone https://github.com/hotheadhacker/no-as-a-service.git .

# Install dependencies
RUN npm ci

# ---- Runner Stage ----
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app /app

USER node

EXPOSE 3000

CMD [ "node", "index.js" ]
