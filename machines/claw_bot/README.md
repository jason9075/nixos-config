# Claw Bot Machine Configuration

This directory contains the NixOS configuration for `claw_bot`, a specialized machine designed for automation using [OpenClaw](https://github.com/openclaw/openclaw).

## Purpose
- **OS**: NixOS (X11)
- **Window Manager**: i3wm (Tiling)
- **Terminal**: `Super+t`
- **Application Launcher**: `Super+f` (Rofi)
- **Close Window**: `Super+q`
- **Focus Window**: `Super + h/j/k/l`
- **Move/Resize**: `Super` + Mouse Left/Right Click
- **Wifi**: System Tray interaction (via `nm-applet`)
- **Power Menu (Shutdown/Reboot)**: `Super+Shift+e` -> Follow on-screen prompts (e.g., `Shift+s` to shutdown).
- **Core Function**: Headless/Automated browser tasks via OpenClaw.

## Installation

1.  **Hardware Configuration**:
    Generate the hardware config for your specific machine:
    ```bash
    nixos-generate-config --show-hardware-config > ./hardware-configuration.nix
    ```
    *(Note: Replace the placeholder `hardware-configuration.nix` currently in this directory)*

2.  **Deploy**:
    From the root of `nixos-config`:
    ```bash
    ./install.sh
    # Select option "claw_bot"
    ```
    Or manually:
    ```bash
    nixos-rebuild switch --flake .#system
    ```

## OpenClaw Setup (NPM Native Mode)

This machine uses a hybrid approach for OpenClaw:
- **System Dependencies**: Managed by Nix (Node.js, Python, GCC, X11 tools, Nix-LD).
- **OpenClaw Package**: Managed by **NPM** (installed to `~/.npm-global`).
- **Service**: Managed by Systemd User Service (`openclaw-gateway`).

### 1. Initial Setup
After deploying the NixOS configuration, run the setup script to install OpenClaw and deploy initial documents:

```bash
./scripts/setup_openclaw.sh
```

This script will:
1. Configure NPM to use `~/.npm-global`.
2. Install OpenClaw via `npm install -g openclaw`.
3. Copy initial documents (SOUL, AGENTS, etc.) to `~/.openclaw/docs`.
4. Start the Systemd service.

### 2. Configuration & Secrets
OpenClaw configuration is stored in `~/.openclaw/openclaw.json`.
You can manage this file manually or via `openclaw config set ...`.

### 3. Documents (The AI's Brain)
The AI's personality and knowledge are stored in `~/.openclaw/docs`.
- **SOUL.md**: Core personality.
- **USER.md**: What it knows about you.
- **AGENTS.md**: Definition of specific agent behaviors.

These files are **NOT** managed by Nix after the initial copy. You are free to edit them.

## Browser Authentication
OpenClaw uses your user session. To allow it to access your accounts:
1. Log in to the machine as your user.
2. Open **Chromium** or **Firefox**.
3. Log in to necessary services (Google, ERP, etc.).
4. Close the browser.

## i3wm Rules (Workspace 9)
- **Workspace 9**: Dedicated to automated tasks (OpenClaw targets).
- **Fullscreen**: Automation targets should be fullscreen to reduce visual noise.

## Troubleshooting

### Service Status
```bash
systemctl --user status openclaw-gateway
journalctl --user -u openclaw-gateway -f
```

### Manual Run (Debug)
If the service fails, try running OpenClaw manually to see errors:
```bash
openclaw gateway run
```

### Update OpenClaw
To update to the latest version, simply run the setup script again:
```bash
./scripts/setup_openclaw.sh
```
Or manually:
```bash
npm install -g openclaw@latest
systemctl --user restart openclaw-gateway
```
