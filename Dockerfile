# syntax=docker/dockerfile:1

# Adapted from https://github.com/linuxserver/docker-chrome/blob/master/Dockerfile
# Multi-platform support (AMD64 / ARM64) — uses Brave Browser with Cloudflare WARP VPN client.

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# Automatic build argument populated by Docker Buildx / Compose
ARG TARGETARCH

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Custom Brave+WARP image version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="custom"

# title
ENV TITLE=Brave \
    PIXELFLUX_WAYLAND=true

# Step 1: Install prerequisite packages for repository management
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Step 2: Set up the official Brave Browser APT repository
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=${TARGETARCH}] https://brave-browser-apt-release.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser-release.list

# Step 3: Set up the Cloudflare WARP APT repository
RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [arch=${TARGETARCH} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ trixie main" > /etc/apt/sources.list.d/cloudflare-client.list

# Step 4: Install Brave Browser along with required fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
    brave-browser \
    fonts-liberation \
    fonts-noto-color-emoji \
    fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# Step 5: Install Cloudflare WARP VPN client
RUN apt-get update && apt-get install -y --no-install-recommends \
    cloudflare-warp \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoclean

# Step 6: Add application icon for the Selkies web interface
RUN curl -fsSLo /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/brave/brave-core/master/app/theme/brave/product_logo_128.png

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
