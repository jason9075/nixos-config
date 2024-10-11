# NixOS Setup

## New Computer


```bash
nix-shell -p git --command "nix run github:jason9075/nixos-config --extra-experimental-features nix-command --extra-experimental-features flakes"
```

Alias

```bash
update
updatesys
```

## Optional

### SSH Key-gen

1. Gen new ssh key
```bash
ssh-keygen
```
2. Use scripts/setup_ssh.sh

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
