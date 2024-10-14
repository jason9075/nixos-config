#!/bin/sh

NIX_CFG_PATH=~/nixos-config

# Prompt for machine selection
echo "Please select your machine:"
echo "1) taipei"
echo "2) taoyuan"
echo "3) simple"
while true; do
  echo "Enter the number of your choice: "
  read -r choice
  case "$choice" in
    1) MACHINE="taipei"; break;;
    2) MACHINE="taoyuan"; break;;
    3) MACHINE="simple"; break;;
    *) echo "Invalid option, please select again.";;
  esac
done

# dotfiles
nix-shell -p git --command "git clone https://github.com/jason9075/nixos-config ~/nixos-config"
nix-shell -p git --command "git clone https://github.com/jason9075/dotfiles ~/.dotfiles"

# Generate hardware config for new system
sudo nixos-generate-config --show-hardware-config | sudo tee $NIX_CFG_PATH/system/hardware-configuration.nix > /dev/null

# Check if uefi or bios
if [ -d /sys/firmware/efi/efivars ]; then
    sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"uefi\";/" $NIX_CFG_PATH/flake.nix
else
    sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"bios\";/" $NIX_CFG_PATH/flake.nix
    grubDevice=$(findmnt / | awk -F' ' '{ print $2 }' | sed 's/\[.*\]//g' | tail -n 1 | lsblk -no pkname | tail -n 1 )
    sed -i "0,/grubDevice.*=.*\".*\";/s//grubDevice = \"\/dev\/$grubDevice\";/" $NIX_CFG_PATH/flake.nix
fi

# Patch flake.nix with different username/name
sed -i "0,/jason9075/s//$(whoami)/" $NIX_CFG_PATH/flake.nix

# Set the selected machine in flake.nix
sed -i "0,/taipei/s//$MACHINE/" $NIX_CFG_PATH/flake.nix

# Confirm flake.nix before install
vim $NIX_CFG_PATH/flake.nix

# Install System
sudo nixos-rebuild switch --flake $NIX_CFG_PATH#system --impure

# Install User
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $NIX_CFG_PATH#user --impure
