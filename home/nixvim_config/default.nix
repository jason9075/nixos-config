{ lib, config, pkgs, ... }:

{
  options.nixvim_config.copilot.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Copilot for auto complete or not.";
  };
  imports = [ ./keybindings.nix ./lsp.nix ];
  config = {
    programs.nixvim = {
      enable = true;

      colorscheme = "nordfox";

      autoCmd = [{
        command = "set filetype=bash";
        event = [ "BufNewFile" "BufRead" ];
        pattern = "*.sh";
      }];

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
        scrolloff = 4;
        sidescrolloff = 4;
        laststatus = 3; # global status line at the bottom
      };

      # Plugins
      plugins = {
        mini.enable = true; # multiple mini functions
        bufferline.enable = true;
        lualine.enable = true;
        project-nvim.enable = true;
        neo-tree = {
          enable = true;
          closeIfLastWindow = true;
          window.position = "right";
          buffers = { followCurrentFile.enabled = true; };
        };
        indent-blankline.enable = true;
        web-devicons.enable = true;

        fzf-lua = {
          enable = true;
          settings = {
            files = { file_ignore_patterns = [ "vendor" "build" ]; };
          };
        };
        refactoring.enable = true;
        comment.enable = true;
        # typescrip commentstring
        ts-context-commentstring.enable = true;
        copilot-lua = {
          enable = config.nixvim_config.copilot.enable;
          suggestion = {
            enabled = true;
            autoTrigger = true;
          };
        };

        luasnip = {
          enable = true;
          # TextChangedI will update the other nodes when the first node is updated.
          settings = { updateevents = "TextChangedI"; };
          fromLua =
            [{ paths = "~/nixos-config/home/nixvim_config/lua_snippets"; }];
          fromVscode =
            [{ paths = "~/nixos-config/home/nixvim_config/vscode_snippets"; }];
        };
        friendly-snippets.enable = true;
        gitsigns.enable = true;

        noice.enable = true;
        notify = {
          enable = true;
          topDown = false;
        };
        tmux-navigator.enable = true;
        nvim-autopairs.enable = true;
        navic.enable = true;

        which-key = {
          enable = true;
          settings = { preset = "helix"; };
        };

        markdown-preview.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        nightfox-nvim # colorscheme
        nui-nvim # ui
        plenary-nvim # testing
        nvim-bufdel # buffer management
        bullets-vim # markdown bullets
      ];

    };
  };
}
