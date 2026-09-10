{ pkgs, pkgs-stable, inputs, userSettings, ... }:

with pkgs;
let
  # Patch trick: https://www.reddit.com/r/NixOS/comments/13bo4fw/how_to_set_flags_for_application/
  patchDesktop = pkg: appName: from: to:
    (pkgs.lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
      ${coreutils}/bin/mkdir -p $out/share/applications
      ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop ''));

  # `programs.hyprland` grants the Hyprland binary CAP_SYS_NICE (via
  # security.wrappers) so the compositor can self-renice to SCHED_RR. Linux
  # keeps that capability in the *ambient* set, which every exec()'d child
  # inherits down the whole tree (Hyprland -> terminal -> shell -> discord).
  # Discord runs through buildFHSEnv, which shells out to bwrap; bwrap refuses
  # to run for a non-setuid caller that unexpectedly carries capabilities
  # ("bwrap: Unexpected capabilities but not setuid, old file caps config?").
  # Re-exec through a throwaway systemd-run unit with an explicit empty
  # AmbientCapabilities= to strip it before bwrap ever sees it, without
  # touching Hyprland's own CAP_SYS_NICE. Wraps both `discord` and `Discord`
  # since the .desktop launcher's Exec= uses the latter.
  discordCapFix = symlinkJoin {
    name = "discord-capfix";
    paths = [ discord ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      for bin in discord Discord; do
        rm -f "$out/bin/$bin"
        makeWrapper ${systemd}/bin/systemd-run "$out/bin/$bin" \
          --add-flags "--user --quiet --collect -p AmbientCapabilities= -- ${discord}/bin/$bin"
      done
    '';
  };
in {
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.sessionVariables = {
    TERMINAL = userSettings.term;
    EDITOR = userSettings.editor;
    BROWSER = userSettings.browser;
  };

  home.stateVersion = "24.05";
  # nixpkgs-unstable已切到下個 release cycle，home-manager master 的版號字串
  # 暫時落後，屬正常過渡期落差，非配置錯誤。
  home.enableNixpkgsReleaseCheck = false;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];

      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/mp3" = [ "vlc.desktop" ];
      "audio/x-wav" = [ "vlc.desktop" ];
      "audio/wav" = [ "vlc.desktop" ];
      "audio/vnd.wave" = [ "vlc.desktop" ];

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
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = {
      default = "gtk";
      "org.freedesktop.impl.portal.Screenshot" = "hyprland";
      "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
      "org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
      # Fallback input-injection path for remote-control tools (RustDesk) when
      # uinput isn't available: routes through Hyprland's own virtual
      # pointer/keyboard protocols instead.
      "org.freedesktop.impl.portal.RemoteDesktop" = "hyprland";
    };
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
    ../../home/cli/visidata.nix
    ../../home/cli/dict # Dictionary
    ../../home/nixvim_config

    # GUI
    ../../home/gui/hyprland.nix
    ../../home/gui/gtk.nix
    ../../home/gui/kitty.nix
    ../../home/gui/ags.nix
    ../../home/gui/hyprlock.nix
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
  hyprland_config.barToggleCommand = "ags request toggle-bar";

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
    psmisc # fuser
    taskwarrior3
    libwebp
    gdu
    gh
    # gh-copilot
    aichat
    cloudflared
    tokei

    # GUI
    hyprland
    pyprland
    hyprcursor
    awww
    swayidle
    grim # Screenshot
    slurp # Screenshot
    swappy # Window switcher
    imv # Image Viewer
    font-manager
    plantuml
    gparted
    anydesk
    rustdesk
    mdbook
    mdbook-plantuml
    obsidian
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    freecad

    # Communication
    slack
    zoom-us
    discordCapFix
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
    meshlab
    libresprite

    # Misc
    wl-clipboard
    wtype
    tree-sitter
    cachix

    inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-cli
    inputs.codex-nix.packages.x86_64-linux.default
    inputs.herdr.packages.x86_64-linux.default
    inputs.fabric.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

}
