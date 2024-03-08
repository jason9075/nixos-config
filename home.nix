{ pkgs, inputs, systemSettings, userSettings, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    # Add your Neovim configuration here. For example:
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      source ~/dotfiles/dot_config/nvim/init.lua
    '';
  };

  imports = [
    inputs.xremap-flake.homeManagerModules.default

    # CLI
    ./home/cli/zsh.nix
    ./home/cli/lazygit.nix

    # GUI
    ./home/gui/hyprland.nix
    ./home/gui/kitty.nix
    ./home/gui/waybar.nix
    ./home/gui/swaylock.nix
    ./home/gui/wlogout.nix
    ./home/gui/rofi.nix
    ./home/gui/mako.nix

    # Audio
    ./home/audio/mpd.nix
  ];


  services.xremap = {
    debug = true;
    withWlroots = true;
    config = {
      modmap = [
        {
          name = "CapsLock to Ctrl";
          remap = {
            "CapsLock" = "Ctrl_L";
          };
        }
      ];
      keymap = [
        # {
        #   name = "kitty";
        #   remap = {
        #     super-i = {
        #         launch = [ "kitty" ];
        #     };
        #   };
        # }
        # { 
        #   name = "Ctrl+h to Left";
        #   remap = {
        #       C-h = "left";
        #   };
        # }
        # { 
        #   name = "Ctrl+j to down";
        #   remap = {
        #       C-j = "down";
        #   };
        # }
        # { 
        #   name = "Ctrl+k to up";
        #   remap = {
        #       C-k = "up";
        #   };
        # }
        # { 
        #   name = "Ctrl+l to right";
        #   remap = {
        #       C-l = "right";
        #   };
        # }
      ];

    };
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Development
    gcc10
    gdb
    gnumake
    cmake

    # CLI
    htop
    nvtop
    ripgrep
    fd
    bat
    zoxide
    wget
    killall
    unzip
    git
    jq
    yq
    fzf
    kitty
    neofetch
    tree

    # GUI
    hyprland
    swayidle
    xfce.thunar

    # Communication
    discord
    slack
    zoom-us
    webcord
    thunderbird

    # Web Browser
    google-chrome
    firefox
    (brave.override { vulkanSupport = true; })

    # Game
    steam

    # Fonts
    font-awesome
    powerline-fonts
    powerline-symbols
    pavucontrol
    (nerdfonts.override { fonts = [ "Hack" ]; })

    # Misc
    wl-clipboard
    tree-sitter
    mpd
    
  ];

  fonts.fontconfig.enable = true;

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-chewing ];

}
