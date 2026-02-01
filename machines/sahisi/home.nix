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
    ../../home/cli/mu.nix
    ../../home/nixvim_config

    # GUI
    ../../home/gui/hyprland.nix
    ../../home/gui/gtk.nix
    ../../home/gui/kitty.nix
    ../../home/gui/waybar.nix
    ../../home/gui/wlogout.nix
    ../../home/gui/rofi.nix
    ../../home/gui/mako.nix
    ../../home/gui/zathura.nix # PDF Viewer

    # Keyboards
    ../../home/keyboards/fcitx.nix
  ];

  home.packages = with pkgs; [

    # Development
    gnumake
    ansible
    entr
    gcc # for neovim tree-sitter

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
    unar # unzip rar files
    jq
    yq
    fzf
    kitty
    tmux
    neofetch
    tree
    russ
    libwebp
    nmap
    samba

    # GUI
    hyprland
    pyprland
    hyprcursor
    swww
    swayidle
    grim # Screenshot
    slurp # Screenshot
    swappy # Window switcher
    imv # Image Viewer
    font-manager

    # Network
    google-chrome
    firefox
    networkmanager
    traceroute

    # Multimedia
    pkgs-stable.gimp # 25.11 unstable breaks gimp
    pavucontrol
    vlc

    # Misc
    wl-clipboard
    wtype
    tree-sitter
  ];

}
