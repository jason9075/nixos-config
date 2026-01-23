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
    # ../../home/gui/qutebrowser.nix
    # ../../home/gui/vscode.nix

    # Audio
    ../../home/audio/mpd.nix

    # Keyboards
    ../../home/keyboards/fcitx.nix
  ];
  nixvim_config.copilot.enable = true;
  eww_config.pomodoro.enable = true;
  eww_config.widgets.enable = true;

  home.packages = with pkgs; [
    # Development
    gnumake
    postman
    ansible
    vpnc
    entr
    nodejs # for github copilot
    gcc # for neovim tree-sitter
    opencode
    zed-editor

    # CLI
    htop
    nvtopPackages.full
    ripgrep
    fd
    bat
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
    fastfetch
    yazi
    tree
    russ
    taskwarrior3
    libwebp
    gh
    # gh-copilot
    aichat
    gemini-cli

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
    gparted
    anydesk

    # Communication
    slack
    zoom-us
    discord
    # webcord

    # Network
    google-chrome
    firefox
    wireguard-tools
    networkmanager
    networkmanager-vpnc

    # Multimedia
    # pkgs-stable.gimp # 25.11 unstable breaks gimp
    gimp
    pavucontrol
    obs-studio
    vlc
    shotcut # Video Editor
    # blender
    # davinci-resolve # Video Editor
    audacity
    # piper-tts # text-to-speech
    # meshlab

    # Misc
    wl-clipboard
    wtype
    tree-sitter
    cachix

    inputs.antigravity-nix.packages.x86_64-linux.default
  ];

}
