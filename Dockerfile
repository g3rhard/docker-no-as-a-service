# ---- Builder Stage ----
FROM node:24-alpine@sha256:c921b97d4b74f51744057454b306b418cf693865e73b8100559189605f6955b8 AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/hotheadhacker/no-as-a-service.git .

# ---- Runner Stage ----
FROM node:24-alpine@sha256:c921b97d4b74f51744057454b306b418cf693865e73b8100559189605f6955b8

WORKDIR /app
COPY --from=builder /app /app
RUN npm install

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=10s --start-period=1s \
  CMD wget --spider http://localhost:3000/no || exit 1

CMD [ "npm", "start" ]
