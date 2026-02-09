# NixOS Setup

## New Computer

It may missing hardware config. Need time to figure out

```bash
nix-shell -p git --command "nix run github:jason9075/nixos-config --no-write-lock-file --extra-experimental-features 'nix-command flakes'"
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

sudo nixos-rebuild switch --flake .#system
home-manager switch --flake .#user
```

Hardware changed.

```bash
sudo nixos-generate-config --show-hardware-config | sudo tee /home/${username}/nixos-config/machines/${machine}/hardware-configuration.nix > /dev/null
```

## Switch Generation

List Generation

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

Change Generation

```bash
sudo nix-env --profile /nix/var/nix/profiles/system/ --switch-generation <number>
```

Delete Gereration

```bash
sudo nix-env --profile /nix/var/nix/profiles/system/ --delete-generations <number>
```

## VPN Setup

The VPN toggle script (`scripts/astra_vpn_toggle.sh`) uses `vpnc` and `NetworkManager`. It requires a configuration file to avoid hardcoding sensitive information.

### Configuration

Create a file at `~/.config/astra-vpn-secret` with the following content (replace values with your actual settings):

```bash
gateway="<vpn.gateway.address>"
group_name="<group-name>"
username="<your-username>"
```

### Password Management

The script integrates with the system keyring via `libsecret` and `zenity`:

1.  **First Run:** It will prompt you for the Group Password via a GUI window.
2.  **Subsequent Runs:** It will automatically retrieve the password from your secure keyring.
3.  **Reset:** To clear the saved password, run: `secret-tool clear service astra-vpn`
