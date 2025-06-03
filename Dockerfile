# ---- Builder Stage ----
FROM node:24-alpine@sha256:91aa1bb6b5f57ec5109155332f4af2aa5d73ff7b4512c8e5dfce5dc88dbbae0e AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/hotheadhacker/no-as-a-service.git .

# ---- Runner Stage ----
FROM node:24-alpine@sha256:91aa1bb6b5f57ec5109155332f4af2aa5d73ff7b4512c8e5dfce5dc88dbbae0e

WORKDIR /app
COPY --from=builder /app /app
RUN npm install

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=10s --start-period=1s \
  CMD wget --spider http://localhost:3000/no || exit 1

CMD [ "npm", "start" ]
