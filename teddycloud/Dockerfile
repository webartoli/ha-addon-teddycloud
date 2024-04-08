ARG TEDDYCLOUD_VERSION="0.4.3"
ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.7

FROM ghcr.io/toniebox-reverse-engineering/teddycloud:${TEDDYCLOUD_VERSION}_alpine as teddycloud

FROM ${BUILD_FROM}

# Install necessary runtime dependencies
RUN apk --no-cache add ffmpeg curl ca-certificates bash

# Update CA certificates
RUN update-ca-certificates

# Create necessary directories
RUN mkdir -p /teddycloud \
    && mkdir -p /usr/local/bin   \
    && mkdir -p /tmp \
    && mkdir -p /config

# Copy artifact from the teddycloud alpine image
COPY --from=teddycloud /teddycloud /teddycloud
COPY --from=teddycloud /usr/local/bin /usr/local/bin
COPY --from=teddycloud /tmp /tmp

# Create /data and /config volder to be mapped into HA as persitent volumes
RUN ln -s /teddycloud/data /data \
    && ln -s /teddycloud/certs /config/certs \
    && ln -s /teddycloud/config /config/config

EXPOSE 80 443

COPY --from=teddycloud docker/docker-entrypoint.sh /
RUN chmod +rx /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]

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