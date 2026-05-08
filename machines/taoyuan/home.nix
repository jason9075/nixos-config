{ pkgs, pkgs-stable, inputs, userSettings, ... }:

with pkgs;
let
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
    BROWSER = "firefox";
  };

  home.stateVersion = "24.05";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];

      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/mp3" = [ "vlc.desktop" ];

      "image/jpeg" = [ "imv.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];

      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];

      "application/pdf" = [ "firefox.desktop" ];

      "inode/directory" = [ "thunar.desktop" ];
      "application/x-directory" = [ "thunar.desktop" ];
    };
  };
  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };
  programs.home-manager.enable = true;

  imports = [
    inputs.nixvim.homeModules.nixvim

    # CLI
    ../../home/cli/zsh.nix
    ../../home/cli/git.nix
    ../../home/cli/lazygit.nix
    ../../home/cli/dict
    ../../home/nixvim_config

    # GUI
    ../../home/gui/hyprland.nix
    ../../home/gui/gtk.nix
    ../../home/gui/kitty.nix
    ../../home/gui/waybar.nix
    ../../home/gui/hyprlock.nix
    ../../home/gui/wlogout.nix
    ../../home/gui/rofi.nix
    ../../home/gui/mako.nix
    ../../home/gui/zathura.nix

    # Keyboards
    ../../home/keyboards/fcitx.nix

  ];

  home.packages = with pkgs; [
    # Development
    gnumake
    postman
    ansible
    vpnc

    # CLI
    htop
    ripgrep
    fd
    bat
    zoxide
    wget
    killall
    zip
    unzip
    jq
    yq
    fzf
    kitty
    tree
    nmap
    claude-code

    # GUI
    hyprland
    pyprland
    awww
    grim # Screenshot
    slurp # Screenshot
    swappy # Window switcher
    imv # Image Viewer

    # Communication
    discord
    slack
    zoom-us
    discord
    thunderbird

    # Web Browser
    google-chrome
    firefox
    (brave.override { vulkanSupport = true; })

    # Multimedia
    pavucontrol
    gimp
    obs-studio
    vlc
    blender
    shotcut

    # Misc
    wl-clipboard
    wtype
    tree-sitter
  ];

}
