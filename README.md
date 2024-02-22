# NixOS Setup

```bash
sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#system

home-manager switch --flake .#user --impure
```
