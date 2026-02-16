#!/bin/sh

# Static NixOS multi-host flake installer (no edits to flake.nix)
NIX_CFG_PATH=~/nixos-config

# List of supported machines (must match flake.nix attributes and machines/<machine> dirs)
machines="taipei taoyuan taoyuan-dad home-msi vbox sahisi clawbot"

echo "Please select your machine host configuration:"
select opt in $machines; do
  if [ -n "$opt" ]; then
    MACHINE="$opt"
    break
  fi
done

# Check if corresponding machine config exists
if [ ! -d "$NIX_CFG_PATH/machines/$MACHINE" ]; then
  echo "ERROR: Config directory $NIX_CFG_PATH/machines/$MACHINE does not exist. Aborting."
  exit 1
fi

# Ensure git repos are up-to-date
update_or_clone() {
  local dir=$1
  local repo=$2
  if [ -d "$dir" ]; then
    echo "Updating $dir..."
    nix-shell -p git --run "git -C $dir pull"
  else
    echo "Cloning $repo..."
    nix-shell -p git --run "git clone $repo $dir"
  fi
}

update_or_clone "$NIX_CFG_PATH" "https://github.com/jason9075/nixos-config"
update_or_clone "$HOME/.dotfiles" "https://github.com/jason9075/dotfiles"

# Generate hardware config if missing
if [ ! -f "$NIX_CFG_PATH/machines/$MACHINE/hardware-configuration.nix" ]; then
  echo "Generating new hardware-configuration.nix for $MACHINE..."
  sudo nixos-generate-config --show-hardware-config | sudo tee "$NIX_CFG_PATH/machines/$MACHINE/hardware-configuration.nix" > /dev/null
fi
if [ ! -f /etc/nixos/hardware-configuration.nix ]; then
  sudo nixos-generate-config --root / --show-hardware-config | sudo tee /etc/nixos/hardware-configuration.nix > /dev/null
fi

# Check that hostname matches $MACHINE
sys_host=$(hostname)
if [ "$sys_host" != "$MACHINE" ]; then
  echo "WARNING: Your hostname is '$sys_host', but you selected machine '$MACHINE'."
  echo "Your flake-based install WILL NOT work unless your hostname matches the machine attribute."
  echo "You can set the hostname now with: sudo hostnamectl set-hostname '$MACHINE'"
  read -p "Proceed anyway? (y/N): " yn
  case $yn in
    [Yy]*) ;;
    *) exit 2;;
  esac
fi

# NixOS system install
set -e

echo "Starting NixOS installation for $MACHINE..."
sudo nixos-rebuild switch --flake "$NIX_CFG_PATH#$MACHINE"

# Home manager (optional, skip if not present)
if grep -q "home-manager" "$NIX_CFG_PATH/flake.nix"; then
  echo "Installing home-manager configs for $MACHINE (if defined)..."
  nix run nixpkgs#home-manager -- switch --flake "$NIX_CFG_PATH#$MACHINE"
fi

echo "Install complete. You are now using static flake configuration for machine: $MACHINE"
