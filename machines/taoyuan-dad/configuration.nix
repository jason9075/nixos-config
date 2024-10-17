{ pkgs, pkgs-stable, systemSettings, userSettings, ... }:

{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/gui/font.nix
    ../../system/keyboards/keyd.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable =
    if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.canTouchEfiVariables =
    if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath;
  boot.loader.grub.enable =
    if (systemSettings.bootMode == "uefi") then false else true;
  boot.loader.grub.device =
    systemSettings.grubDevice; # does nothing if running uefi rather than bios

  # GUI
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  networking.hostName = "nixos-kuan33400";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  programs.zsh.enable = true;
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = "Kuan";
    extraGroups = [ "networkmanager" "wheel" "vboxsf" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ firefox ];
  };

  # nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [ vim git pulseaudio ];

  # List services that you want to enable:
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = systemSettings.version;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.allowed-users = [ "root" userSettings.username ];

}
