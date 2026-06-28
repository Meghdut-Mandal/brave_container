# syntax=docker/dockerfile:1

# Adapted from https://github.com/linuxserver/docker-chrome/blob/master/Dockerfile
# Modified for ARM64 (aarch64) support — uses Chromium instead of Google Chrome
# since Google Chrome does not yet provide ARM64 Linux packages.
# Includes Cloudflare WARP VPN client.

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Custom ARM64 Chrome+WARP image version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="custom"

# title
ENV TITLE=Brave \
    PIXELFLUX_WAYLAND=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/brave/brave-core/master/app/theme/brave/product_logo_128.png && \
  echo "**** install brave ****" && \
  curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=arm64] https://brave-browser-apt-release.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser-release.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    brave-browser \
    fonts-liberation \
    fonts-noto-color-emoji \
    fonts-noto-cjk && \
  echo "**** install cloudflare warp ****" && \
  curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg \
    | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
  echo "deb [arch=arm64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ trixie main" \
    > /etc/apt/sources.list.d/cloudflare-client.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cloudflare-warp && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
