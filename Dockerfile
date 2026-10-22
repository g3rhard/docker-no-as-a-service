# ---- Builder Stage ----
FROM public.ecr.aws/docker/library/alpine:3.24@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS builder

WORKDIR /app

RUN apk add --no-cache git

# renovate: datasource=git-refs depName=https://github.com/hotheadhacker/no-as-a-service.git versioning=git
ARG NO_AS_A_SERVICE_REF=764062a307c725cb55f56308ee842f5e42529dd1
RUN git clone https://github.com/hotheadhacker/no-as-a-service.git . && git checkout "$NO_AS_A_SERVICE_REF"

# ---- Runner Stage ----
FROM public.ecr.aws/docker/library/node:24-alpine@sha256:06d7adf3e0ef61a13f1d28682726366f97a15aa1888c934d3ecec86c33918b53

WORKDIR /app
COPY --from=builder /app /app
RUN npm install

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=10s --start-period=1s \
  CMD wget --spider http://localhost:3000/no || exit 1

CMD [ "npm", "start" ]
