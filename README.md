# Chromium ARM64 Docker Image

Web-accessible Chromium browser inside a Debian container, adapted from [linuxserver/docker-chrome](https://github.com/linuxserver/docker-chrome) for **ARM64 / Apple Silicon (macOS)**.

## Why Chromium Instead of Chrome?

Google Chrome only provides Linux packages for `amd64` (x86-64). This image uses **Chromium** — the open-source project Chrome is built on — which has native ARM64 packages available in Debian repositories.

## Architecture

This image is built on top of [`ghcr.io/linuxserver/baseimage-selkies:debiantrixie`](https://github.com/linuxserver/docker-baseimage-selkies) which provides:

- **Selkies** — WebRTC-based remote desktop streaming (low-latency, 60+ FPS)
- **Wayland compositor** (Labwc) with X11 fallback
- **NGINX** for web serving and basic auth
- **PulseAudio** for audio capture
- **s6 overlay** for process supervision

## Quick Start

### Build & Run with Docker Compose (Recommended)

```bash
docker compose up -d --build
```

Then open your browser to: **https://localhost:3001/**

> **Note:** The container uses a self-signed HTTPS certificate. Your browser will show a security warning — accept it to proceed.

### Build & Run with Docker CLI

```bash
# Build the image
docker build -t chromium-arm64 .

# Run the container
docker run -d \
  --name chromium \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Kolkata \
  -v $(pwd)/config:/config \
  -p 3000:3000 \
  -p 3001:3001 \
  --shm-size="1gb" \
  chromium-arm64
```

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `Etc/UTC` | Timezone |
| `CUSTOM_USER` | *(unset)* | Username for basic HTTP auth |
| `PASSWORD` | *(unset)* | Password for basic HTTP auth |
| `CHROME_CLI` | *(unset)* | Additional CLI flags/URL passed to Chromium |
| `PIXELFLUX_WAYLAND` | `true` | Set to `false` to force X11 fallback |

## Ports

| Port | Protocol | Description |
|---|---|---|
| `3000` | HTTPS | Web UI |
| `3001` | HTTPS | Web UI (alternative) |

## Security

> ⚠️ **Warning:** This container provides privileged access to the host system. Do not expose it to the Internet without proper security.

- HTTPS is required for full functionality (WebCodecs, audio, etc.)
- By default there is no authentication — set `CUSTOM_USER` and `PASSWORD` for basic auth
- For internet exposure, place behind a reverse proxy with robust authentication
- The web UI includes a terminal with passwordless `sudo` access

## Volumes

| Path | Description |
|---|---|
| `/config` | Persistent configuration and user data |

## Credits

Based on [linuxserver/docker-chrome](https://github.com/linuxserver/docker-chrome) by the [LinuxServer.io](https://linuxserver.io) team.
