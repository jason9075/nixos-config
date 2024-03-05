{ pkgs, inputs, ... }:

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

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -alh";
      v = "nvim";
      update = "sudo nixos-rebuild switch";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-completions";}
        { name = "zsh-users/zsh-autosuggestions"; } 
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    initExtra = ''
      bindkey -v
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp)
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down
      bindkey '^g' autosuggest-accept
      export ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
      export BAT_THEME="Nord"

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  imports = [
    inputs.xremap-flake.homeManagerModules.default
    ./home/gui/kitty.nix
    ./home/gui/hyprland.nix
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
        {
          name = "kitty";
          remap = {
            super-i = {
                launch = [ "kitty" ];
            };
          };
        }
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

    # GUI
    waybar
    hyprland
    swww
    swayidle

    # Communication
    discord
    slack
    zoom-us

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
    (nerdfonts.override { fonts = [ "Hack" ]; })

    # Misc
    xclip
    tree-sitter
    
  ];

  fonts.fontconfig.enable = true;

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-chewing ];

}

