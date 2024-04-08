{ pkgs, ...}:

{
  imports = [
    ./keybindings
  ];
  programs.nixvim = {
    enable = true;

    colorschemes.nord.enable = true;

    opts = {
      termguicolors = true;
      number = true;
      relativenumber = true;
      clipboard = "unnamedplus";
      completeopt = "menuone,noselect";
      timeoutlen = 300;

      shiftwidth = 2;
    };

    # Plugins
    plugins = {
      bufferline.enable = true;
      lualine.enable = true;
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        window.position = "right";
      };
      indent-blankline.enable = true;

      fzf-lua.enable = true;
      refactoring.enable = true;
      comment.enable = true;
      copilot-vim.enable = true;

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "treesitter"; }
          ];
          snippet = {
            expand = ''
              function(args)
                  require('luasnip').lsp_expand(args.body)
                end
              '';
          };
        };
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true; 
      cmp-path.enable = true;
      cmp-treesitter.enable = true;
      cmp_luasnip.enable = true;

      lspsaga.enable = true;
      luasnip.enable = true;
      gitsigns.enable = true;
      none-ls = {
        enable = true;
        diagnosticConfig = {
          virtual_text = false;
          signs = true;
          update_in_insert = false;
          underline = true;
          severity_sort = true;
        };
        sources = {
          formatting = {
            gofumpt.enable = true;
            goimports_reviser.enable = true;
            golines.enable = true;
            nixfmt.enable = true;
            hclfmt.enable = true;
            stylua.enable = true;
            prettierd.enable = true;
            yamlfmt.enable = true;
            black.enable = true;
          };
          diagnostics = {
            dotenv_linter.enable = true;
            pylint.enable = true;
          };
        };

        onAttach = ''
          function(client, bufnr)
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({
                  group = augroup,
                  buffer = bufnr
              })
              vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup,
                  buffer = bufnr,
                  callback = function()
                      vim.lsp.buf.format({
                          bufnr = bufnr
                      })
                  end
              })
            end
          end
        '';
      };
      treesitter.enable = true; 
      treesitter-textobjects.enable = true;
      treesitter-refactor.enable = true;

      noice.enable = true;
      tmux-navigator.enable = true;
      nvim-autopairs.enable = true;
      navic.enable = true;
      notify.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      nvim-lspconfig

      nui-nvim
      plenary-nvim
      nvim-bufdel
    ];

  };

}
