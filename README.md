# NixOS Setup

## New Computer

1. Disable System Suspend

2. Install git and vim temporarily

```bash
nix-shell -p git
nix-shell -p vim
```

3. Clone this project and dotfiles

```bash
git clone https://github.com/jason9075/nixos-config.git
git clone https://github.com/jason9075/dotfiles.git
```

4. Home Manager

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

Then logout and login again

```bash
nix-shell '<home-manager>' -A install
```

5. Install

```bash
cd nixos-config
sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#system --impure

home-manager switch --flake .#user --impure
```

Alias

```bash
update
updatesys
```

## Optional

### SSH Key-gen

```bash
ssh-keygen
```

### Config File

```bash
Host me.github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_ed25519
```

### Change git project from https to ssh

```bash
git remote set-url origin <ssh path>
```

## Update NixOS Version

[Doc](https://nixos.org/manual/nixos/stable/index.html#sec-upgrading)

```bash
sudo nix-channel --update
sudo nix flake update
```
