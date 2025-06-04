#!/bin/sh
set -e

NIX_CFG_PATH="${NIX_CFG_PATH:-$HOME/nixos-config}"

# Prompt for machine selection
echo "Please select your machine:"
echo "1) taipei"
echo "2) taoyuan"
echo "3) taoyuan-dad"
echo "4) home-msi"
echo "5) vbox"
while true; do
  read -rp "Enter the number of your choice: " choice
  case "$choice" in
    1) MACHINE="taipei"; break;;
    2) MACHINE="taoyuan"; break;;
    3) MACHINE="taoyuan-dad"; break;;
    4) MACHINE="home-msi"; break;;
    5) MACHINE="vbox"; break;;
    *) echo "Invalid option, please select again.";;
  esac
done

# Clone or update repositories on demand
update_or_clone() {
  local dir=$1
  local repo=$2
  if [ -d "$dir" ]; then
    echo "Updating $dir..."
    nix-shell -p git --command "git -C $dir pull"
  else
    echo "Cloning $repo..."
    nix-shell -p git --command "git clone $repo $dir"
  fi
}

# Update or clone repositories
update_or_clone "$NIX_CFG_PATH" "https://github.com/jason9075/nixos-config"
update_or_clone "$HOME/.dotfiles" "https://github.com/jason9075/dotfiles"

# Generate hardware config for new system
sudo nixos-generate-config --show-hardware-config | sudo tee "$NIX_CFG_PATH/system/hardware-configuration.nix" > /dev/null
[ ! -f /etc/nixos/hardware-configuration.nix ] && \
  sudo nixos-generate-config --show-hardware-config | sudo tee /etc/nixos/hardware-configuration.nix > /dev/null

# Check if uefi or bios
if [ -d /sys/firmware/efi/efivars ]; then
    boot_mode="uefi"
else
    boot_mode="bios"
    grub_device=$(lsblk -no pkname "$(findmnt / -o SOURCE -n)" | tail -n 1)
    sed -i "s|grubDevice = \".*\";|grubDevice = \"/dev/$grub_device\";|" "$NIX_CFG_PATH/flake.nix"
fi
sed -i "s|bootMode = \".*\";|bootMode = \"$boot_mode\";|" "$NIX_CFG_PATH/flake.nix"

# Patch flake.nix with different username/name
sed -i "0,/jason9075/s//$(whoami)/" "$NIX_CFG_PATH/flake.nix"

# Set the selected machine in flake.nix
sed -i "0,/taipei/s//$MACHINE/" "$NIX_CFG_PATH/flake.nix"

# Confirm flake.nix before install
vim "$NIX_CFG_PATH/flake.nix"

# Install System and User
echo "Installing system..."
sudo nixos-rebuild switch --flake "$NIX_CFG_PATH"#system

echo "Installing user..."
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake "$NIX_CFG_PATH"#user
