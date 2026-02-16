{ pkgs, lib, userSettings, ... }:

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

       # FZF（極致優化：延遲載入綁定）
       FZF_LOADED=0
       lazy-load-fzf() {
         if [[ $FZF_LOADED -eq 0 ]]; then
           FZF_LOADED=1
           source "$(fzf-share)/key-bindings.zsh"
           source "$(fzf-share)/completion.zsh"
         fi
       }
       for key in ctrl-t alt-c; do
         bindkey "^$key" lazy-load-fzf
       done

      export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden --exclude vendor --exclude external'
      export FZF_DEFAULT_OPTS='--reverse --no-height --color=bg+:#343d46,gutter:-1,pointer:#bf616a,info:#ebcb8b,hl:#0dbc79,hl+:#23d18b'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_CTRL_T_OPTS='--preview "bat --color=always {}" --bind "alt-n:preview-down,alt-p:preview-up,alt-s:toggle-sort"'
      export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
      export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

      # Zoxide（極致優化：延遲載入）
      lazy-load-zoxide() {
        unalias z 2>/dev/null
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        z "$@"
      }
      alias z=lazy-load-zoxide

      # Use difftastic for git diff
      # export GIT_EXTERNAL_DIFF=difft


    '';
in {
  programs.zsh = {
    enable = true;
    # 最佳化補全（不要多次 compinit）
    completionInit = "autoload -Uz compinit && compinit -C";
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
        NH_FLAKE="/home/${userSettings.username}/nixos-config" nh home switch --'';
      # old: cd ~/nixos-config/ && sudo nixos-rebuild switch --flake .#system && cd -
      updatesys = ''
        NH_FLAKE="/home/${userSettings.username}/nixos-config" nh os switch --'';
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

    plugins = [
      { name = "zsh-autosuggestions"; src = pkgs.zsh-autosuggestions; }
      { name = "zsh-syntax-highlighting"; src = pkgs.zsh-syntax-highlighting; }
      { name = "zsh-completions"; src = pkgs.zsh-completions; }
      { name = "zsh-history-substring-search"; src = pkgs.zsh-history-substring-search; }
      { name = "zsh-vi-mode"; src = pkgs.zsh-vi-mode; }
    ];

    initContent = lib.mkMerge [ beforeRc extraRc ("source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme") ];

  };
  home.file.".p10k.zsh".source = ./p10k_config.zsh;

}
