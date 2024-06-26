# NixOS Setup

## Home Manager

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
nix-channel --update
```

After Logout

```bash
nix-shell '<home-manager>' -A install
```

```bash
sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#system --impure

home-manager switch --flake .#user --impure
```

## Update

[Doc](https://nixos.org/manual/nixos/stable/index.html#sec-upgrading)

```bash
sudo nix-channel --update
sudo nix flake update
```
