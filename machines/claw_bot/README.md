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

## OpenClaw Setup (Nix-Managed)

This machine uses a Nix-managed OpenClaw service defined in `../../home/services/openclaw.nix`.

### 1. Secret Setup
The following files **must** exist in `~/.secrets/` for the configuration to build:
- `openai_key`: Your API key.
- `telegram_token`: Your @BotFather token.
- `gateway_token`: The pairing token.

### 2. Activation
To apply the OpenClaw settings (personality, tools, agents):
1. Stage changes: `git add .`
2. Apply: `nh home switch --flake .#user -- --impure`
3. Restart: `systemctl --user restart openclaw-gateway`

### 3. Documents (The AI's Brain)
The AI's personality and knowledge are stored in `../../home/services/openclaw/docs/`:
- `SOUL.md`: Core personality.
- `USER.md`: What it knows about you (Jason).
- `AGENTS.md`: Definition of specific agent behaviors.

## Browser Authentication
OpenClaw uses your user session. To allow it to access your accounts:
1. Log in to the machine as your user.
2. Open **Firefox** or **Chrome**.
3. Log in to necessary services (Google, ERP, etc.).
4. Close the browser.

## i3wm Rules (Workspace 9)
- **Workspace 9**: Dedicated to automated tasks (OpenClaw targets).
- **Fullscreen**: Automation targets should be fullscreen to reduce visual noise.

## Troubleshooting
- **Check Status**: `systemctl --user status openclaw-gateway`
- **Check Logs**: `journalctl --user -u openclaw-gateway -f`
- **Gateway Log**: `tail -f /tmp/openclaw/openclaw-gateway.log`
