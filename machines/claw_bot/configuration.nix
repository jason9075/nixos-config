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

  # Disable Sleep/Hibernate
  powerManagement.enable = false;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
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
    
    windowManager.i3.enable = true;
    windowManager.i3.configFile = pkgs.writeText "i3.conf" ''
      # i3 config file (v4)
      font pango:monospace 8

      # Mod Key
      set $mod Mod4

      # Basic Bindings
      bindsym $mod+t exec ${pkgs.kitty}/bin/kitty
      bindsym $mod+q kill
      bindsym $mod+d exec ${pkgs.dmenu}/bin/dmenu_run

      # Focus
      bindsym $mod+h focus left
      bindsym $mod+j focus down
      bindsym $mod+k focus up
      bindsym $mod+l focus right
      
      # Rofi
      bindsym $mod+f exec ${pkgs.rofi}/bin/rofi -show drun

      # Floating modifier
      floating_modifier $mod

      # Reload/Restart
      bindsym $mod+Shift+c reload
      bindsym $mod+Shift+r restart

      # Fullscreen
      bindsym $mod+m fullscreen toggle


      # Window Rules for OpenClaw
      for_window [class="OpenClaw-Target"] move to workspace 9
      new_window none
      new_float none
      
      # Enhance Focus Visibility
      default_border pixel 3
      client.focused          #bf616a #bf616a #d8dee9 #bf616a   #bf616a
      client.focused_inactive #2e3440 #2e3440 #d8dee9 #2e3440   #2e3440
      client.unfocused        #2e3440 #2e3440 #d8dee9 #2e3440   #2e3440
      client.urgent           #2e3440 #900000 #ffffff #900000   #900000
      client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c

      client.background       #ffffff

      # Bar
      bar {
        position top
        status_command ${pkgs.i3status}/bin/i3status
        tray_output primary
      }

      # Auto-start Applications
      exec --no-startup-id ${pkgs.networkmanagerapplet}/bin/nm-applet
      exec --no-startup-id ${pkgs.xorg.xset}/bin/xset s off -dpms

      # Power Menu Mode (Shutdown/Reboot)
      set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
      mode "$mode_system" {
          bindsym l exec --no-startup-id ${pkgs.i3lock}/bin/i3lock, mode "default"
          bindsym e exec --no-startup-id i3-msg exit, mode "default"
          bindsym s exec --no-startup-id systemctl suspend, mode "default"
          bindsym h exec --no-startup-id systemctl hibernate, mode "default"
          bindsym r exec --no-startup-id systemctl reboot, mode "default"
          bindsym Shift+s exec --no-startup-id systemctl poweroff -i, mode "default"  
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }
      bindsym $mod+Shift+e mode "$mode_system"
    '';

    displayManager.sddm.enable = true;
    
    # Auto-login for the bot user
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = userSettings.username;

    # Set default session to i3
    displayManager.defaultSession = "none+i3";
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
    
    # GUI Utils
    networkmanagerapplet
    i3lock
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
  nix.settings.substituters = [ "https://cache.nixos.org/" "https://cache.garnix.io" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libxcrypt-legacy ];

  programs.dconf.enable = true;

}
