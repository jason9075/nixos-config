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
        clangd = {
          enable = true;
          filetypes = [ "c" "cpp" "objc" "objcpp" "cuda" ];
        };
        eslint = { enable = true; };
        html = { enable = true; };
        ts_ls = { enable = true; };
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
    lspkind = {
      enable = true;
      cmp = {
        enable = true;
        menu = {
          nvim_lsp = "[LSP]";
          path = "[Path]";
          luasnip = "[Snip]";
          buffer = "[Buf]";
        };
      };
    };
    none-ls = {
      enable = true;
      sources = {
        formatting = {
          gofmt.enable = true;
          nixfmt.enable = true;
          hclfmt.enable = true;
          prettierd.enable = true;
          djlint.enable = true;
          yamlfmt.enable = true;
          prettierd.disableTsServerFormatter = true;
          stylua = {
            enable = true;
            settings = {
              extra_args = [ "--indent-type" "Spaces" "--indent-width" "2" ];
            };
          };
          black = {
            enable = true;
            settings = { extra_args = [ "--fast" ]; };
          };
          clang_format = {
            enable = true;
            settings = {
              withArgs = # lua
                ''
                  {
                    extra_args = { "--style={BasedOnStyle: Google, ColumnLimit: 120}" },
                    extra_filetypes = { "glsl" },
                  }
                '';
            };
          };
        };
        diagnostics = {
          dotenv_linter.enable = true;
          pylint = {
            enable = true;
            settings = {
              extra_args = [
                "--disable=C0114,C0115,C0116" # disable docstring warnings
                "--max-locals=35" # R0914 too many local variables warning
                "--disable=R0913" # too many arguments warning
              ];
            };
          };
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
          { name = "path"; }
          { name = "luasnip"; }
          {
            name = "buffer";
            keyword_length = 5; # show buffer completion after 5 characters
          }
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
        indent.enable = true;
        highlight = {
          enable = true;
          disable = [ "htmldjango" "jinja" "jinja2"];
        };
      };
    };
    treesitter-context.enable = true;
    treesitter-textobjects.enable = true;
    treesitter-refactor.enable = true;
    # syntax highlight for nix config
    hmts.enable = true;
    plantuml-syntax.enable = true;
  };

  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

}
