{ pkgs, pkgs-stable, systemSettings, userSettings, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/gui/hyprland.nix
    ../../system/gui/thunar.nix
    ../../system/gui/fonts
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


  networking.hostName = "sahisi";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-vpnc ];

  # Set your time zone.
  time.timeZone = systemSettings.timezone;
  time.hardwareClockInLocalTime = true;

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

  virtualisation.docker.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
  users.users.sahisi = {
    isNormalUser = true;
    description = "上海興";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ firefox ];
  };

  # nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
  };

  # Swaylock
  security.pam.services.swaylock = { };

  # Color scheme
  stylix.enable = true;
  stylix.image = ./wallpaper.png; # dummy image
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font powerline-fonts ];
    font = "ter-powerline-v24b";
    colors = [
      "2e3440"
      "3b4252"
      "434c5e"
      "4c566a"
      "d8dee9"
      "e5e9f0"
      "eceff4"
      "8fbcbb"
      "88c0d0"
      "81a1c1"
      "5e81ac"
      "bf616a"
      "d08770"
      "ebcb8b"
      "a3be8c"
      "b48ead"
    ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [ vim git pulseaudio ];

  # List services that you want to enable:
  services.openssh.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.allowed-users = [ "root" "sahisi" ];

  systemd.services.sa-hi-si-erp = {
    description = "Sa-Hi-Si ERP docker stack";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "docker.service" ];
    wants = [ "network-online.target" "docker.service" ];

    serviceConfig = {
      Type = "simple";
      User = "sahisi";
      Group = "users";
      WorkingDirectory = "/home/sahisi/sa-hi-si-erp";
      ExecStart = "/run/current-system/sw/bin/make run";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

}
