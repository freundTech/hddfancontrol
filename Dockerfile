FROM rust:alpine AS build

RUN apk add --no-cache clang lld

COPY . /app
WORKDIR /app

RUN --mount=type=cache,target=/root/.cargo/git/db \
    --mount=type=cache,target=/root/.cargo/registry/cache \
    --mount=type=cache,target=/root/.cargo/registry/index \
    cargo build --release

FROM alpine:latest
ARG CREATED
ARG REVISION
LABEL org.opencontainers.image.authors="desbma"
LABEL org.opencontainers.image.created=${CREATED}
LABEL org.opencontainers.image.description="Regulate fan speed according to hard drive temperature"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.source="https://github.com/desbma/hddfancontrol"
LABEL org.opencontainers.image.title="hddfancontrol"

COPY --from=build /app/target/release/hddfancontrol /bin
ENTRYPOINT [ "/bin/hddfancontrol" ]
