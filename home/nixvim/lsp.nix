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
        clangd = { enable = true; };
        eslint = { enable = true; };
        html = { enable = true; };
        ts-ls = { enable = true; };
        yamlls = { enable = true; };
        nixd = {
          enable = true;
          settings = {
            nixpkgs = { expr = "import <nixpkgs> {}"; };
            options = {
              nixos.expr = ''
                (builtins.getFlake "github:jason9075/nixos-config").nixosConfigurations.system.options
              '';
              home_manager.expr = ''
                (builtins.getFlake "github:jason9075/nixos-config").homeConfigurations.user.options
              '';
            };
          };
        };
      };
    };
    lsp-format.enable = true;
    none-ls = {
      enable = true;
      sources = {
        formatting = {
          gofmt.enable = true;
          nixfmt.enable = true;
          hclfmt.enable = true;
          stylua.enable = true;
          prettierd.enable = true;
          yamlfmt.enable = true;
          black.settings = {
            enable = true;
            withArgs = ''
              {
                extra_args = { "--fast" },
              }
            '';
          };
          clang_format.settings = {
            enable = true;
            withArgs = # lua
              ''
                {
                  extra_args = { "--style={BasedOnStyle: Google, ColumnLimit: 120}" },
                  extra_filetypes = { "glsl" },
                }
              '';
          };
        };
        diagnostics = {
          dotenv_linter.enable = true;
          pylint.enable = true;
          zsh.enable = true;
        };
      };
      settings = {
        diagnostic_config = {
          virtual_text = false;
          signs = true;
          update_in_insert = false;
          underline = true;
          severity_sort = true;
        };
      };
    };
    otter.enable = true;
    cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "treesitter"; }
        ];
        snippet = {
          expand = # lua
            ''
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
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        auto_install = true;
        highlight.enable = true;
        indent.enable = true;
      };
    };
    treesitter-context.enable = true;
    treesitter-textobjects.enable = true;
    treesitter-refactor.enable = true;
    # syntax highlight for nix config
    hmts.enable = true;
  };

  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

}
