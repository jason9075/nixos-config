{ pkgs, pkgs-stable, inputs, userSettings, ... }:

with pkgs;
let
in {
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.sessionVariables = {
    TERMINAL = userSettings.term;
    EDITOR = "zed-editor";
    BROWSER = "chromium";
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
    ../../home/gui/dunst.nix
    ../../home/gui/zathura.nix # PDF Viewer
    ../../home/gui/zed.nix

    # Keyboards
    ../../home/keyboards/fcitx.nix
    ../../home/services/openclaw.nix
  ];
  
  nixvim_config.copilot.enable = false;

  home.packages = with pkgs; [
    # Development
    gnumake
    postman
    ansible
    gcc
    opencode
    just
    imagemagick
    grim
    xdotool
    ydotool
    scrot

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
    plantuml
    libwebp

    # GUI
    imv # Image Viewer
    font-manager
    dbeaver-bin

    # Communication
    slack
    zoom-us
    discord
    telegram-desktop
    firefox

    # Network
    networkmanager
    networkmanager-vpnc

    # Multimedia
    gimp
    pavucontrol
    vlc

    # Misc
    xclip
    cachix

    inputs.antigravity-nix.packages.x86_64-linux.default
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "ophjlpahpchlmihnnnihgmmeilfjmjjc"; } # LINE
    ];
  };

  # Fcitx5 settings
  xdg.configFile."fcitx/config".text = ''
    TriggerKey=SUPER_SPACE
  '';

}
