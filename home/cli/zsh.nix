{ pkgs, ... }:

let
  beforeRc = ''
    # p10k instant prompt
    P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
    [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
  '';
  extraRc = ''
    bindkey -v
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp)
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
    bindkey '^g' autosuggest-accept
    export ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
    export BAT_THEME="Nord"

    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

    eval "$(zoxide init zsh)"

    # FZF
    source "$(fzf-share)/key-bindings.zsh"
    source "$(fzf-share)/completion.zsh"

    export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
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
      update = "cd ~/nixos-config/ && home-manager switch --flake .#user --impure && cd -";
      icat = "kitty +kitten icat";
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
    initExtraBeforeCompInit = beforeRc;
    initExtra = extraRc;
  };
  home.file.".p10k.zsh".source = ~/dotfiles/dot_p10k.zsh;

}
