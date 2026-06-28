# ARM64 Dockerized Brave Browser with Cloudflare WARP

This repository contains a fully configured Docker environment for running the **Brave Browser** seamlessly on ARM64 (Apple Silicon / aarch64 Linux) architectures. 

It provides an isolated browsing environment accessible via a web browser using WebRTC (Selkies/KasmVNC), completely routed through a Cloudflare WARP VPN tunnel.

## Key Features

- **Brave Browser (ARM64)**: Uses the official Brave APT repository for native aarch64 performance, replacing standard Chromium.
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
**https://localhost:6969**

### 3. Initialize the VPN

On the first run, execute the setup script to register and connect the Cloudflare WARP tunnel:

```bash
docker exec brave setup-warp
```

*(You can verify the connection status at any time by running `docker exec brave warp-cli --accept-tos status`)*

## Configuration

- **Ports:** The default web interface is exposed on port `6969`.
- **Volumes:** 
  - `./config`: Persists your Brave Browser profile data and settings.
  - `warp_data`: A Docker volume that persists your WARP registration status across container restarts.

## Notes
- To completely reset your browser, delete the `config` directory on your host.
- The repository includes a `.gitignore` to prevent committing your personal `config/` data.
