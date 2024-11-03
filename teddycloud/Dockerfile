FROM node:alpine as web

WORKDIR /app

RUN apk --no-cache add git

RUN git clone https://github.com/toniebox-reverse-engineering/teddycloud_web . \
 && rm .env* \
 && npm ci \
 && npm run build

ARG TEDDYCLOUD_VERSION="0.6.2"
ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable

FROM ghcr.io/toniebox-reverse-engineering/teddycloud:${TEDDYCLOUD_VERSION}_alpine as teddycloud

FROM ${BUILD_FROM}

# Install necessary runtime dependencies
RUN apk --no-cache add ffmpeg curl ca-certificates bash

# Update CA certificates
RUN update-ca-certificates

# Create necessary directories
RUN mkdir -p /teddycloud \
    && mkdir -p /usr/local/bin   \
    && mkdir -p /tmp

# Copy artifact from the teddycloud alpine image
COPY --from=teddycloud /teddycloud/ /teddycloud/
COPY --from=teddycloud /usr/local/bin/ /usr/local/bin/
COPY --from=teddycloud /tmp/ /tmp/
COPY --from=web /app/dist/ /teddycloud/data/www/

EXPOSE 80 443 8443

COPY --from=teddycloud --chmod=550 /docker-entrypoint.sh /
CMD /ha-tc/init && /docker-entrypoint.sh

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Claudio Bartoli <claudio@barto.li>" \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="Claudio Bartoli <claudio@barto.li>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
