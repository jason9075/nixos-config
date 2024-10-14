{ pkgs, pkgs-stable, nixvim, systemSettings, userSettings, ... }:

with pkgs;
let
in {
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.sessionVariables = { EDITOR = userSettings.editor; };

  home.stateVersion = "24.11"; # Unstable

  programs.home-manager.enable = true;

  imports = [
    nixvim.homeManagerModules.nixvim

    # CLI
    ../../home/cli/zsh.nix
    ../../home/cli/git.nix
    ../../home/cli/lazygit.nix
    ../../home/nixvim

    # GUI
    ../../home/gui/gtk.nix
    ../../home/gui/kitty.nix

    # Keyboards
    ../../home/keyboards/fcitx.nix
  ];

  home.packages = with pkgs; [
    # Development
    ansible

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
    gimp
    vlc

    # Misc
    xclip
    xdotool
    tree-sitter
  ];
}
