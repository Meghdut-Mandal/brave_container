# Multi-Platform Dockerized Brave Browser with Cloudflare WARP

This repository contains a fully configured Docker environment for running the **Brave Browser** seamlessly on both **ARM64** (Apple Silicon / aarch64) and **AMD64** (x86_64) architectures. 

It provides an isolated browsing environment accessible via a web browser using WebRTC (Selkies/KasmVNC), completely routed through a Cloudflare WARP VPN tunnel.

## Key Features

- **Brave Browser (Multi-Platform)**: Automatically installs the native Brave browser package matching the host architecture (ARM64 or AMD64).
- **Cloudflare WARP Integration**: Traffic inside the container is automatically routed through a Cloudflare WARP VPN tunnel.
- **Background Daemon Management**: The WARP daemon is managed natively by `s6-overlay`, ensuring reliable background execution and automatic restarts.
- **Web-Based Access**: The browser interface is streamed directly to a web browser on your host machine via a secure HTML5 client.
- **Vertical Tabs Optimized**: The Wayland window manager (`labwc`) has been configured with `NO_DECOR=true` to completely hide the top system title bar, providing maximum screen real estate for vertical tab workflows.

## Setup & Usage

### 1. Build and Start the Container

```bash
docker compose up -d --build
```

### 2. Access the Browser

Open your local browser and navigate to:
- **Primary Web UI**: [https://localhost:6969](https://localhost:6969)
- **Alternative Web UI**: [https://localhost:6970](https://localhost:6970)

> **Note:** The container uses a self-signed HTTPS certificate. Your browser will show a security warning — accept it to proceed.

### 3. Initialize the VPN

On the first run, execute the setup script to register and connect the Cloudflare WARP tunnel:

```bash
docker exec brave setup-warp
```

*(You can verify the connection status at any time by running `docker exec brave warp-cli --accept-tos status`)*

## Configuration

### Ports

The host port mappings have been updated to avoid conflicts:

| Host Port | Container Port | Protocol | Description |
|---|---|---|---|
| `6969` | `3000` | HTTPS | Primary HTTPS Web UI |
| `6970` | `3001` | HTTPS | Alternative HTTPS Web UI |

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `Asia/Kolkata` | Timezone |
| `CUSTOM_USER` | *(unset)* | Username for basic HTTP auth |
| `PASSWORD` | *(unset)* | Password for basic HTTP auth |
| `CHROME_CLI` | *(unset)* | Additional CLI flags or starting URL passed to Brave |
| `NO_DECOR` | `true` | Set to `true` to hide window decorations/title bar (optimized for vertical tabs) |
| `PIXELFLUX_WAYLAND` | `true` | Set to `false` to force X11 fallback |

### Volumes

- `./config`: Persists your Brave Browser profile data and settings.
- `warp_data`: A Docker volume that persists your WARP registration status across container restarts.

## Security & Privileges

To support GUI applications and VPN tunnel routing, the container requires the following options in `docker-compose.yml`:
- `security_opt: - seccomp=unconfined` (Required for GUI app syscall compatibility)
- `cap_add: - NET_ADMIN` (Required for Cloudflare WARP VPN to manage interfaces)
- `devices: - /dev/net/tun:/dev/net/tun` (Exposes the tun device to the container)

## Notes
- To completely reset your browser, delete the `config` directory on your host.
- The repository includes a `.gitignore` to prevent committing your personal `config/` data.
