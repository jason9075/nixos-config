# Claw Bot Machine Configuration

This directory contains the NixOS configuration for `claw_bot`, a specialized machine designed for automation using [OpenClaw](https://github.com/openclaw/openclaw).

## Purpose
- **OS**: NixOS (X11)
- **Window Manager**: i3wm (Tiling)
- **Terminal**: `Super+t`
- **Application Launcher**: `Super+f` (Rofi)
- **Close Window**: `Super+q`
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
    # Ensure flake.nix has machine = "claw_bot"
    ```

## Post-Installation Setup

### 1. Telegram Integration (OpenClaw)
To control this bot via Telegram:

1.  **Create Bot**: Chat with [@BotFather](https://t.me/botfather) on Telegram to create a new bot and get your **API Token**.
2.  **Link Provider**:
    Run the following command on `claw_bot`:
    ```bash
    openclaw providers add --provider telegram --token "YOUR_BOT_TOKEN_HERE"
    ```
3.  **Start Chatting**: Message your bot on Telegram. You may need to verify the pairing code if prompted.

### 2. Browser Authentication
OpenClaw uses your user session. To allow it to access your accounts:

1.  Log in to the machine as your user.
2.  Open **Firefox** or **Chrome**.
3.  Log in to necessary services (Google, ERP, etc.).
4.  Close the browser.
    *OpenClaw will now inherit these session cookies.*

## i3wm Rules (Workspace 9)
This configuration enforces strict window management for automation stability:
- **Workspace 9**: Dedicated to automated tasks (OpenClaw targets).
- **Fullscreen**: Automation targets should be fullscreen to reduce visual noise.
- **No Borders**: Borders are removed to improve CV accuracy.

## Managing Cost & Tokens (Service Control)
To prevent the bot from consuming API tokens when not in use, you can stop the background service.

**Check Status**:
```bash
systemctl --user status openclaw
```

**Stop Bot** (Save Tokens):
```bash
systemctl --user stop openclaw
```

**Start Bot**:
```bash
systemctl --user start openclaw
```

## Troubleshooting
- **Build Failures**: Check if `nix-command` experimental feature is enabled (the install script handles this).
- **OpenClaw Service**: Check logs:
    ```bash
    journalctl --user -u openclaw -f
    ```
