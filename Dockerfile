# ---- Builder Stage ----
FROM node:24-alpine@sha256:f8baf2c963e3bff767993135ae3447bb433e8d64a5e4bb65780cd29ef3a525c2 AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/hotheadhacker/no-as-a-service.git .

# ---- Runner Stage ----
FROM node:24-alpine@sha256:f8baf2c963e3bff767993135ae3447bb433e8d64a5e4bb65780cd29ef3a525c2

WORKDIR /app
COPY --from=builder /app /app
RUN npm install

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=10s --start-period=1s \
  CMD wget --spider http://localhost:3000/no || exit 1

CMD [ "npm", "start" ]
