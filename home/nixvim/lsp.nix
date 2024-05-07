{ pkgs, ... }:

{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        pyright = { enable = true; };
        bashls = { enable = true; };
        dockerls = { enable = true; };
        gopls = { enable = true; };
      };
    };

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

    lsp-format = {
      enable = true;
      setup = { gofmt = { force = true; }; };
    };
    none-ls = {
      enable = true;
      enableLspFormat = true;
      diagnosticConfig = {
        virtual_text = false;
        signs = true;
        update_in_insert = false;
        underline = true;
        severity_sort = true;
      };
      sources = {
        formatting = {
          gofmt.enable = true;
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
                vim.lsp.buf.format({ async = false })
              end
            })
          end
        end
      '';
    };
    treesitter.enable = true;
    treesitter-textobjects.enable = true;
    treesitter-refactor.enable = true;
  };

}
