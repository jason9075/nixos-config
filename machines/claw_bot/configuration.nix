{ pkgs, pkgs-stable, systemSettings, userSettings, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/networking/wireguard.nix
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

  networking.hostName = systemSettings.hostname;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-vpnc ];
  networking.useDHCP = false;

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

  # Enable CUPS to print documents.
  services.printing.enable = false; # Disabled for bot

  services.atd.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  programs.zsh.enable = true;
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 3";
  };

  # Color scheme
  stylix.enable = true;
  stylix.image = ./wallpaper.png; # dummy image, user needs to ensure this exists or I will create one
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
      "123456" # placeholder for last color if needed or just use consistent palette
    ];
  };

  # X11 & i3 Configuration
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
    };
    displayManager.startx.enable = true; # Or use lightdm/gdm? Let's use startx or simple display manager.
    # Usually we want a display manager.
    # displayManager.gdm.enable = true; 
    # Let's assume default unless specified. Or just enable one. 
  };
  # User request: "Level 1 (Direct CLI): ... Level 2 (IPC Control) ... Level 3 (OpenClaw Visual)"
  
  environment.systemPackages = with pkgs; [ 
    vim git wayland pulseaudio 
    
    # Core Automation Tools
    xdotool
    xorg.xwininfo
    scrot
    
    # App Launcher
    rofi
    
    # OpenClaw Dependencies
    python311Packages.pyautogui
    python311Packages.pillow
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  services.fstrim.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 8000 ];

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.settings.warn-dirty = false;
  nix.settings.allowed-users = [ "root" userSettings.username ];
  
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libxcrypt-legacy ];

}
