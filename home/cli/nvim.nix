{ pkgs, ...}:

{
  programs.neovim = {
    enable = true;
    # Add your Neovim configuration here. For example:
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      source ~/dotfiles/dot_config/nvim/init.lua
    '';
  };

}
