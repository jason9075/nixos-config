{ lib, userSettings, ... }:

let
  beforeRc = lib.mkOrder 550 # bash
    ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
  extraRc = # bash
    ''
      bindkey -v
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp)
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down
      bindkey '^g' autosuggest-accept
      export ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
      export BAT_THEME="Nord"

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # FZF
      source "$(fzf-share)/key-bindings.zsh"
      source "$(fzf-share)/completion.zsh"

      export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden --exclude vendor --exclude external'
      export FZF_DEFAULT_OPTS='--reverse --no-height --color=bg+:#343d46,gutter:-1,pointer:#bf616a,info:#ebcb8b,hl:#0dbc79,hl+:#23d18b'

      # find files
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_CTRL_T_OPTS='--preview "bat --color=always {}" --bind "alt-n:preview-down,alt-p:preview-up,alt-s:toggle-sort"'

      # cd to dir
      export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
      export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
    '';
in {
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -alh";
      v = "nvim";
      lg = "lazygit";
      gd = "git diff";
      gs = "git -c delta.side-by-side=true diff";
      ssh = "kitty +kitten ssh";
      open = "thunar";
      icat = "kitty +kitten icat";
      # old: cd ~/nixos-config/ && home-manager switch --flake .#user && cd -
      update = ''
        NH_FLAKE="/home/${userSettings.username}/nixos-config" nh home switch -c user --'';
      # old: cd ~/nixos-config/ && sudo nixos-rebuild switch --flake .#system && cd -
      updatesys = ''
        NH_FLAKE="/home/${userSettings.username}/nixos-config" nh os switch -H system --'';
      nixdev = "nix develop --command zsh";
      # delete old generations
      nixdel = "nix-env --delete-generations 7d";
      nixdelsys =
        "nix-env --delete-generations --profile /nix/var/nix/profiles/system 7d";
      # list generations
      nixls = "nix-env --list-generations";
      nixlssys =
        "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      # delete old nix store (unreferenced and older than 7 days)
      nixgc = "sudo nix-collect-garbage --delete-older-than 7d";
      # tts
      speak = "~/nixos-config/scripts/speak.sh";
      # docker
      dps =
        "docker ps --format 'table {{.Names}}	{{.RunningFor}}	{{.Status}}	{{.Image}}	{{.ID}}	{{.Size}}' -a";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        {
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" ];
        }
      ];
    };
    initContent = lib.mkMerge [ beforeRc extraRc ];
  };
  home.file.".p10k.zsh".source = ./p10k_config.zsh;

}
