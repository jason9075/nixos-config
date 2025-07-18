{ pkgs, pkgs-stable, nixvim, userSettings, ... }:

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

  imports = [
    nixvim.homeManagerModules.nixvim

    # CLI
    ../../home/cli/zsh.nix
    ../../home/cli/git.nix
    ../../home/cli/lazygit.nix
    ../../home/cli/mu.nix
    ../../home/cli/dict # Dictionary
    ../../home/nixvim_config

    # GUI
    ../../home/gui/hyprland.nix
    ../../home/gui/gtk.nix
    ../../home/gui/kitty.nix
    ../../home/gui/waybar.nix
    ../../home/gui/swaylock.nix
    ../../home/gui/wlogout.nix
    ../../home/gui/rofi.nix
    ../../home/gui/mako.nix
    ../../home/gui/zathura.nix # PDF Viewer
    ../../home/gui/qutebrowser.nix
    ../../home/gui/vscode.nix

    # Audio
    ../../home/audio/mpd.nix

    # Keyboards
    ../../home/keyboards/fcitx.nix
  ];
  nixvim_config.copilot.enable = true;

  home.packages = with pkgs; [
    # Development
    gnumake
    postman
    ansible
    vpnc
    entr
    nodejs # for github copilot

    # CLI
    htop
    nvtopPackages.full
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
    taskwarrior3
    libwebp
    gh
    gh-copilot

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
    plantuml

    # Communication
    slack
    (patchDesktop slack "slack" "^Exec=${slack}/bin/slack -s %U"
      "Exec=${slack}/bin/slack --enable-wayland-ime -s %U")
    zoom-us
    webcord
    (patchDesktop webcord "webcord" "^Exec=webcord"
      "Exec=webcord --enable-wayland-ime")
    thunderbird

    # Network
    # google-chrome
    (chromium.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    })
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    })
    firefox
    (brave.override { vulkanSupport = true; })
    # pcmanx-gtk2
    wireguard-tools
    traceroute

    # Multimedia
    pkgs-stable.gimp # 25.11 unstable breaks gimp
    pavucontrol
    obs-studio
    vlc
    shotcut # Video Editor
    # blender
    # davinci-resolve # Video Editor
    audacity
    piper-tts # text-to-speech
    meshlab

    # Misc
    wl-clipboard
    wtype
    tree-sitter
    cachix
  ];

}
