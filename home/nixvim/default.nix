{ pkgs, ... }:

{
  imports = [ ./keybindings.nix ./lsp.nix ];
  programs.nixvim = {
    enable = true;

    colorscheme = "nordfox";

    opts = {
      termguicolors = true;
      number = true;
      relativenumber = true;
      clipboard = "unnamedplus";
      completeopt = "menuone,noselect";
      timeoutlen = 300;

      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      wrap = false;
      smartcase = true;
      ignorecase = true;
      smartindent = true;
    };

    # Plugins
    plugins = {
      bufferline.enable = true;
      lualine.enable = true;
      project-nvim.enable = true;
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        window.position = "right";
      };
      indent-blankline.enable = true;

      fzf-lua.enable = true;
      refactoring.enable = true;
      comment.enable = true;
      copilot-lua = {
        enable = true;
        suggestion = {
          enabled = true;
          autoTrigger = true;
        };
      };

      luasnip.enable = true;
      gitsigns.enable = true;

      noice.enable = true;
      notify = {
        enable = true;
        topDown = false;
      };
      tmux-navigator.enable = true;
      nvim-autopairs.enable = true;
      navic.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      nightfox-nvim
      nvim-lspconfig

      nui-nvim
      plenary-nvim
      nvim-bufdel
    ];

  };

}
