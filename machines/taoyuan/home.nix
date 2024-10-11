{ pkgs, pkgs-stable, nixvim, systemSettings, userSettings, ... }:

with pkgs;
let
  # Patch trick: https://www.reddit.com/r/NixOS/comments/13bo4fw/how_to_set_flags_for_application/
  patchDesktop = pkg: appName: from: to:
    (pkgs.lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
      ${coreutils}/bin/mkdir -p $out/share/applications
      ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop ''));
in {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.sessionVariables = { EDITOR = userSettings.editor; };

  # home.stateVersion = "24.05"; # Stable
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
    ../../home/gui/hyprland.nix
    ../../home/gui/gtk.nix
    ../../home/gui/kitty.nix
    ../../home/gui/waybar.nix
    ../../home/gui/swaylock.nix
    ../../home/gui/wlogout.nix
    ../../home/gui/rofi.nix
    ../../home/gui/mako.nix
    ../../home/gui/zathura.nix # PDF Viewer

    # Keyboards
    ../../home/keyboards/fcitx.nix

  ];

  home.packages = with pkgs; [
    # Development
    gcc10
    gdb
    gnumake
    cmake
    nodejs
    postman
    ansible
    vpnc

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
    jq
    yq
    fzf
    kitty
    neofetch
    tree

    # GUI
    hyprland
    pyprland
    swww
    swayidle
    grim # Screenshot
    slurp # Screenshot
    swappy # Window switcher
    imv # Image Viewer

    # Communication
    discord
    slack
    (patchDesktop slack "slack" "^Exec=${slack}/bin/slack -s %U"
      "Exec=${slack}/bin/slack --enable-wayland-ime -s %U")
    zoom-us
    webcord
    (patchDesktop webcord "webcord" "^Exec=webcord"
      "Exec=webcord --enable-wayland-ime")
    thunderbird

    # Web Browser
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    })
    firefox
    (brave.override { vulkanSupport = true; })

    # Multimedia
    gimp
    obs-studio
    vlc
    blender

    # Misc
    wl-clipboard
    wtype
    tree-sitter
  ];

}
