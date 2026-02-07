{ pkgs, pkgs-stable, inputs, userSettings, ... }:

with pkgs;
let
  # Patch trick: https://www.reddit.com/r/NixOS/comments/13bo4fw/how_to_set_flags_for_application/
  patchDesktop = pkg: appName: from: to:
    (pkgs.lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
      ${coreutils}/bin/mkdir -p $out/share/applications
      ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop ''));
in {
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.sessionVariables = {
    TERMINAL = userSettings.term;
    EDITOR = userSettings.editor;
    BROWSER = userSettings.browser;
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
  programs.zoxide.enable = true;

  imports = [
    inputs.nixvim.homeModules.nixvim

    # CLI
    ../../home/cli/zsh.nix
    ../../home/cli/git.nix
    ../../home/cli/lazygit.nix
    ../../home/cli/mu.nix
    ../../home/nixvim_config

    # GUI
    ../../home/gui/gtk.nix
    ../../home/gui/kitty.nix
    ../../home/gui/rofi.nix # Useful for i3 as well
    ../../home/gui/mako.nix
    ../../home/gui/zathura.nix # PDF Viewer

    # Keyboards
    ../../home/keyboards/fcitx.nix
    
    ../../home/services/openclaw.nix
  ];
  
  #programs.openclaw.enable = true;


  nixvim_config.copilot.enable = true;

  home.packages = with pkgs; [
    # Development
    gnumake
    postman
    ansible
    gcc
    zed-editor
    opencode

    # CLI
    htop
    fd
    wget
    killall
    zip
    unzip
    unar # unzip rar files
    jq
    yq
    fzf
    kitty
    yazi
    tree
    russ
    libwebp

    # GUI
    imv # Image Viewer
    font-manager

    # Communication
    slack
    zoom-us
    discord

    # Network
    google-chrome
    wireguard-tools
    networkmanager
    networkmanager-vpnc

    # Multimedia
    gimp
    pavucontrol
    # obs-studio
    vlc
    # shotcut # Video Editor
    # audacity

    # Misc
    wl-clipboard
    wtype
    cachix

  ];

}
