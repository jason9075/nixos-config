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

      # `nixpkgs.source` wants a path to a Nixpkgs tree, not "flake"/"legacy".
      # Point it at the same Nixpkgs instance already in scope so nixvim
      # doesn't re-import a second copy (silences the version-mismatch warning).
      nixpkgs.source = pkgs.path;

      colorscheme = "nordfox";

      autoCmd = [
        {
          command = "set filetype=bash";
          event = [ "BufNewFile" "BufRead" ];
          pattern = "*.sh";
        }
        {
          event = [ "FileType" ];
          pattern = [ "csv" "tsv" ];
          callback = {
            __raw = ''
              function()
                vim.treesitter.stop(0)
                vim.b.ts_highlight = nil
                vim.bo.syntax = vim.bo.filetype
              end
            '';
          };
        }
        {
          event = [ "FileType" ];
          pattern = [ "markdown" "text" ];
          callback = {
            __raw = ''
              function()
                vim.opt_local.wrap = false
                vim.opt_local.conceallevel = 2
              end
            '';
          };
        }
      ];

      opts = {
        termguicolors = true;
        number = true;
        relativenumber = true;
        clipboard = "unnamedplus";
        completeopt = "menuone,noselect";
        timeoutlen = 300;
        foldlevel = 99;
        foldlevelstart = 99;
        foldenable = true;

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
        direnv.enable = true;
        mini.enable = true; # multiple mini functions
        bufferline.enable = true;
        lualine.enable = true;
        project-nvim.enable = true;
        nvim-ufo = {
          enable = true;
          settings = {
            provider_selector.__raw = ''
              function(bufnr, filetype, buftype)
                return {'treesitter', 'indent'}
              end
            '';
          };
        };
        neo-tree = {
          enable = true;
          settings = {
            close_if_last_window = true;
            window.position = "right";
            buffers = { follow_current_file.enabled = true; };
          };
        };
        snacks = {
          enable = true;
          settings = {
            input.enabled = true;
            picker.enabled = true;
            terminal.enabled = true;
          };
        };
        indent-blankline.enable = true;
        web-devicons.enable = true;
        image = {
          enable = true;
          settings = {
            integrations = {
              markdown = {
                enabled = true;
                clear_in_insert_mode = false;
                download_remote_images = true;
                only_render_image_at_cursor = true;
                only_render_image_at_cursor_mode = "popup";
                floating_windows =
                  false; # will be rendered in floating markdown windows
              };
              html = { enabled = false; };
              css = { enabled = false; };
            };
          };
        };

        fzf-lua = {
          enable = true;
          settings = {
            files = { file_ignore_patterns = [ "vendor" "build" ]; };
          };
        };
        refactoring.enable = true;
        comment.enable = true;
        colorizer.enable = true;
        # typescrip commentstring
        ts-context-commentstring.enable = true;
        # copilot-lua = {
        #   enable = config.nixvim_config.copilot.enable;
        #   settings.suggestion = {
        #     enabled = true;
        #     autoTrigger = true;
        #   };
        # };
        # opencode = {
        #   enable = true;
        #   settings = {
        #     port = 4097;
        #     provider = {
        #       enabled = "kitty";
        #       kitty = {
        #         args = [ "--class" "opencode" ];
        #       };
        #     };
        #   };
        # };
        # copilot-vim.enable = config.nixvim_config.copilot.enable;

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

        # git
        gitsigns.enable = true;
        # fugitive.enable = true;
        lazygit.enable = true;
        diffview.enable = true;

        noice.enable = true;
        notify.settings = {
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
        harpoon.enable = true;

        markdown-preview.enable = true;
        markview.enable = true;
        # outline.nvim was dropped from nixvim; not replacing it.
      };

      # refactoring.nvim depends on lewis6991/async.nvim, which also exposes a
      # top-level `require('async')` — same module name as nvim-ufo's
      # kevinhwang91/promise-async. Whichever plugin lands first on the
      # packpath wins that name, and async.nvim's table isn't callable the
      # way ufo expects, crashing every fold update with
      # "attempt to call upvalue 'async' (a table value)".
      # `package.preload` is checked before any packpath search, so registering
      # promise-async's loader there pins `require('async')` to it regardless
      # of packpath scan order or which plugin resolves the name first.
      extraConfigLuaPre = ''
        package.preload['async'] = function()
          return dofile('${pkgs.vimPlugins.promise-async}/lua/async.lua')
        end
      '';

      extraPlugins = with pkgs.vimPlugins; [
        nightfox-nvim # colorscheme
        nui-nvim # ui
        plenary-nvim # testing
        nvim-bufdel # buffer management
        bullets-vim # markdown bullets
        rainbow_csv # color CSV/TSV columns
        # vim-table-mode # commented out to avoid conflict with markview table rendering
        vim-jinja
      ];
      extraPackages = with pkgs; [ lsof ];

    };
  };
}
