{ pkgs, pkgs-stable, inputs, userSettings, ... }:

with pkgs;
let
in {
  home.username = "sahisi";
  home.homeDirectory = "/home/sahisi";

  home.sessionVariables = {
    TERMINAL = userSettings.term;
    EDITOR = userSettings.editor;
    BROWSER = "google-chrome";
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    # CLI
    ../../home/cli/zsh.nix
    ../../home/cli/git.nix
    ../../home/cli/lazygit.nix
    ../../home/nixvim_config

    # GUI
    ../../home/gui/kitty.nix
    ../../home/gui/eww.nix

    # Keyboards
    ../../home/keyboards/fcitx.nix
  ];

  home.packages = with pkgs; [

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
    neofetch
    tree

    # Web Browser
    google-chrome
    firefox

    # Multimedia
    vlc

    # Misc
    xclip
    xdotool
    tree-sitter
    wmctrl
  ];

  # Cinnamon auto start
  home.file.".config/autostart/run_once.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=/home/jason9075/nixos-config/scripts/cinnamon_login.sh
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name=Run eww
    Comment=Run once on login
  '';
}
