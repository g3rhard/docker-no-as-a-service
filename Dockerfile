# ---- Builder Stage ----
FROM node:20-alpine AS builder

WORKDIR /app

# Install git
RUN apk add --no-cache git

USER node

# Clone the repository
RUN git clone https://github.com/hotheadhacker/no-as-a-service.git .

# ---- Runner Stage ----
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app /app

USER node

# Install dependencies
RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]
