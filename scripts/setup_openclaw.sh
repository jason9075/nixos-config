#!/usr/bin/env bash
set -e

# Configuration
DOCS_SOURCE="$HOME/nixos-config/home/services/openclaw/docs"
DOCS_TARGET="$HOME/.openclaw/docs"
NPM_GLOBAL="$HOME/.npm-global"

echo "🦞 Setting up OpenClaw (NPM Native Mode)..."

# 1. Ensure .npmrc exists
if [ ! -f "$HOME/.npmrc" ]; then
    echo "Creating .npmrc..."
    echo "prefix=$NPM_GLOBAL" > "$HOME/.npmrc"
fi

# 2. Install OpenClaw via NPM
# We check if openclaw is in the path, but since we modify PATH in .bashrc/.zshrc 
# it might not be visible in this script shell if it's non-interactive or fresh.
# So we check the binary directly.
if [ ! -f "$NPM_GLOBAL/bin/openclaw" ]; then
    echo "Installing OpenClaw via NPM..."
    npm install -g openclaw
else
    echo "OpenClaw is already installed. Updating..."
    npm install -g openclaw
fi

# 3. Deploy Documents (The Brain)
echo "Deploying documents from $DOCS_SOURCE to $DOCS_TARGET..."
mkdir -p "$DOCS_TARGET"
# Copy only if source files are newer or missing (no overwrite)
# cp -n does not overwrite
cp -rn "$DOCS_SOURCE/"* "$DOCS_TARGET/" || true
echo "Note: Existing files were NOT overwritten to preserve your changes."

# 4. Restart Service
echo "Restarting OpenClaw Gateway service..."
systemctl --user daemon-reload
systemctl --user restart openclaw-gateway

# 5. Verify
echo "Verifying installation..."
# Wait a moment for service to attempt start
sleep 2
if systemctl --user is-active --quiet openclaw-gateway; then
    echo "✅ OpenClaw Gateway is RUNNING."
    echo "   Logs: journalctl --user -u openclaw-gateway -f"
else
    echo "❌ OpenClaw Gateway failed to start."
    echo "   Check logs: journalctl --user -u openclaw-gateway -n 20"
fi
