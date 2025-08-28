# ---- Builder Stage ----
FROM node:24-alpine@sha256:be4d5e92ac68483ec71440bf5934865b4b7fcb93588f17a24d411d15f0204e4f AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/hotheadhacker/no-as-a-service.git .

# ---- Runner Stage ----
FROM node:24-alpine@sha256:be4d5e92ac68483ec71440bf5934865b4b7fcb93588f17a24d411d15f0204e4f

WORKDIR /app
COPY --from=builder /app /app
RUN npm install

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=10s --start-period=1s \
  CMD wget --spider http://localhost:3000/no || exit 1

CMD [ "npm", "start" ]
