{ pkgs, userSettings, ... }:

{
  programs.neovim = {
    enable = true;
    # Add your Neovim configuration here. For example:
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      source ${userSettings.dotfilesDir}/dot_config/nvim/init.lua
    '';
  };

}
