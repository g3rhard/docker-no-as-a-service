# ---- Builder Stage ----
FROM public.ecr.aws/docker/library/alpine:3.24@sha256:8ddefa941e689fc29abcdeb8dae3b3c6d139cc08ce9a52633931160701770685 AS builder

WORKDIR /app

RUN apk add --no-cache git

# renovate: datasource=git-refs depName=https://github.com/hotheadhacker/no-as-a-service.git versioning=git
ARG NO_AS_A_SERVICE_REF=764062a307c725cb55f56308ee842f5e42529dd1
RUN git clone https://github.com/hotheadhacker/no-as-a-service.git . && git checkout "$NO_AS_A_SERVICE_REF"

# ---- Runner Stage ----
FROM public.ecr.aws/docker/library/node:24-alpine@sha256:fb71d01345f11b708a3553c66e7c74074f2d506400ea81973343d915cb64eef0

WORKDIR /app
COPY --from=builder /app /app
RUN npm install

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=10s --start-period=1s \
  CMD wget --spider http://localhost:3000/no || exit 1

CMD [ "npm", "start" ]
