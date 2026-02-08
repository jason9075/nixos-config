#!/usr/bin/env bash
set -e

# Configuration
DOCS_SOURCE="$HOME/nixos-config/home/services/openclaw/docs"
DOCS_TARGET="$HOME/.openclaw/docs"
SKILLS_SOURCE="$HOME/nixos-config/home/services/openclaw/skills"
SKILLS_TARGET="$HOME/.openclaw/skills"
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

# Check if IDENTITY.md needs personalization
IDENTITY_FILE="$DOCS_TARGET/IDENTITY.md"
TEMPLATE_IDENTITY="$DOCS_SOURCE/IDENTITY.md"

# Function to prompt with default
prompt_val() {
    local prompt="$1"
    local var_name="$2"
    local default="$3"
    read -p "$prompt [$default]: " val
    eval $var_name="\${val:-$default}"
}

if [ ! -f "$IDENTITY_FILE" ] || grep -q "{{" "$IDENTITY_FILE"; then
    echo "Personalizing your AI Identity..."
    
    # Defaults
    DEFAULT_MACHINE=$(hostname)
    DEFAULT_USER=$USER
    DEFAULT_COMPANY="Personal"
    DEFAULT_ROLE="User"

    prompt_val "Machine Name (AI's Name)" MY_MACHINE "$DEFAULT_MACHINE"
    prompt_val "Your Name" MY_USER "$DEFAULT_USER"
    prompt_val "Company" MY_COMPANY "$DEFAULT_COMPANY"
    prompt_val "Your Role" MY_ROLE "$DEFAULT_ROLE"

    # Copy and replace placeholders
    sed -e "s/{{MACHINE_NAME}}/$MY_MACHINE/g" \
        -e "s/{{USER_NAME}}/$MY_USER/g" \
        -e "s/{{COMPANY_NAME}}/$MY_COMPANY/g" \
        -e "s/{{USER_ROLE}}/$MY_ROLE/g" \
        "$TEMPLATE_IDENTITY" > "$IDENTITY_FILE"
    
    echo "IDENTITY.md personalized."
fi

# Copy other files only if source files are newer or missing (no overwrite)
# cp -n does not overwrite
cp -rn "$DOCS_SOURCE/"* "$DOCS_TARGET/" || true
echo "Note: Existing files were NOT overwritten to preserve your changes."

# 4. Deploy Skills
echo "Deploying skills from $SKILLS_SOURCE to $SKILLS_TARGET..."
mkdir -p "$SKILLS_TARGET"
# Skills can be overwritten as they are code/logic, not user state
if [ -d "$SKILLS_SOURCE" ]; then
    cp -r "$SKILLS_SOURCE/"* "$SKILLS_TARGET/"
    echo "Skills updated."
else
    echo "No skills directory found at $SKILLS_SOURCE."
fi

# 5. Restart Service
echo "Restarting OpenClaw Gateway service..."
systemctl --user daemon-reload
systemctl --user restart openclaw-gateway

# 6. Verify
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
