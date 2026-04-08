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

  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # 可選：讓 direnv 的訊息安靜一點
    # config.global.hide_env_diff = true;
  };

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
    ../../home/gui/swaync.nix
    ../../home/gui/zathura.nix # PDF Viewer
    ../../home/gui/zed.nix
    # ../../home/gui/qutebrowser.nix
    # ../../home/gui/vscode.nix

    # Audio
    ../../home/audio/mpd.nix

    # Keyboards
    ../../home/keyboards/fcitx.nix
  ];
  nixvim_config.copilot.enable = false;
  eww_config.pomodoro.enable = true;
  eww_config.widgets.enable = true;

  home.packages = with pkgs; [
    # Development
    gnumake
    postman
    ansible
    libsecret
    zenity
    seahorse
    vpnc
    entr
    nodejs # for github copilot
    gcc # for neovim tree-sitter
    opencode
    claude-code
    just

    # CLI
    htop
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
    lsof
    taskwarrior3
    libwebp
    gdu
    gh
    # gh-copilot
    aichat
    gemini-cli
    cloudflared

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
    mdbook

    # Communication
    slack
    zoom-us
    discord
    # webcord

    # Network
    google-chrome
    chromium
    firefox
    wireguard-tools
    networkmanager
    networkmanager-vpnc
    httptoolkit

    # Multimedia
    # pkgs-stable.gimp # 25.11 unstable breaks gimp
    gimp
    pavucontrol
    obs-studio
    vlc
    shotcut # Video Editor
    blender
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
    inputs.codex-nix.packages.x86_64-linux.default
    inputs.fabric.packages.${pkgs.system}.default
  ];

}
