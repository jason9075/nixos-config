{ pkgs, pkgs-stable, inputs, userSettings, ... }:

with pkgs;
let
in {
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.sessionVariables = {
    TERMINAL = userSettings.term;
    EDITOR = userSettings.editor;
    BROWSER = qutebrowser;
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

    # Keyboards
    ../../home/keyboards/fcitx.nix
  ];

  home.packages = with pkgs; [

    # CLI
    gnumake
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
    tmux
    tree

    # Web Browser
    qutebrowser
    google-chrome
    firefox

    # Misc
    wl-clipboard
    wtype
    tree-sitter
  ];
}
