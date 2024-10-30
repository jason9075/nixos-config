{ pkgs, ... }:

{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        mode = "i";
        key = "kj";
        options.silent = true;
        action = "<Esc>";
      }
      {
        mode = "n";
        key = "<S-l>";
        options.silent = true;
        action = ":bnext<CR>";
      }
      {
        mode = "n";
        key = "<S-h>";
        options.silent = true;
        action = ":bprevious<CR>";
      }
      {
        mode = "n";
        key = "<S-j>";
        options.silent = true;
        action = "5<C-e>";
      }
      {
        mode = "n";
        key = "<S-k>";
        options.silent = true;
        action = "5<C-y>";
      }
      # Disable default completion, use cmp instead
      {
        mode = "i";
        key = "<C-n>";
        action = "<Nop>";
      }
      {
        mode = "i";
        key = "<C-p>";
        action = "<Nop>";
      }
    ];
    plugins = {
      which-key = {
        settings.spec = [
          {
            __unkeyed-1 = "<leader>e";
            __unkeyed-2 = ":Neotree reveal toggle<CR>";
            desc = "Toggle file explorer";
            icon = "";
          }
          {
            __unkeyed-1 = "<leader>q";
            __unkeyed-2 = ":q<CR>";
            desc = "Quit";
          }
          {
            __unkeyed-1 = "<leader>Q";
            __unkeyed-2 = ":q!<CR>";
            desc = "Force quit";
          }
          {
            __unkeyed-1 = "<leader>w";
            __unkeyed-2 = ":w<CR>";
            desc = "Save";
            icon = "";
          }
          {
            __unkeyed-1 = "<leader>x";
            __unkeyed-2 = ":BufDel<CR>";
            desc = "Close buffer";
            icon = "";
          }
          {
            __unkeyed-1 = "<leader>m";
            __unkeyed-2 = ":make<CR>";
            desc = "Make";
            icon = "";
          }
          {
            __unkeyed-1 = "<leader>n";
            __unkeyed-2 = ":Noice dismiss<CR>";
            desc = "Noice dismiss";
          }
          {
            __unkeyed-1 = "<leader>l";
            __unkeyed-2 = ":LspInfo<CR>";
            desc = "LspInfo";
            icon = "";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "Show";
            icon = "";
          }
          {
            __unkeyed-1 = "<leader>sl";
            __unkeyed-2 = ":lua vim.diagnostic.open_float()<CR>";
            desc = "Show diagnostics";
          }
          {
            __unkeyed-1 = "<leader>sh";
            __unkeyed-2 = ":lua vim.lsp.buf.hover()<CR>";
            desc = "Show hover";
          }
          {
            __unkeyed-1 = "<leader>r";
            group = "Refactor";
            icon = "󰷉";
          }
          {
            __unkeyed-1 = "<leader>rf";
            __unkeyed-2 = ":Format<CR>";
            desc = "Format";
          }
          {
            __unkeyed-1 = "<leader>rr";
            __unkeyed-2 = ":lua vim.lsp.buf.rename()<CR>";
            desc = "Rename";
          }
          {
            __unkeyed-1 = "<leader>ri";
            __unkeyed-2 =
              ":lua require('refactoring').refactor('Inline Variable')<CR>";
            desc = "Inline";
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
            icon = "";
          }
          {
            __unkeyed-1 = "<leader>fD";
            __unkeyed-2 = ":lua vim.lsp.buf.declaration()<CR>";
            desc = "Find declaration";
          }
          {
            __unkeyed-1 = "<leader>fd";
            __unkeyed-2 = ":lua vim.lsp.buf.definition()<CR>";
            desc = "Find definition";
          }
          {
            __unkeyed-1 = "<leader>fe";
            __unkeyed-2 = ":lua vim.diagnostic.goto_next()<CR>";
            desc = "Find next error";
          }
          {
            __unkeyed-1 = "<leader>fr";
            __unkeyed-2 = ":FzfLua lsp_references<CR>";
            desc = "Find references";
          }
          {
            __unkeyed-1 = "<leader>ff";
            __unkeyed-2 = ":FzfLua files<CR>";
            desc = "Find files";
          }
          {
            __unkeyed-1 = "<leader>fg";
            __unkeyed-2 = ":FzfLua live_grep<CR>";
            desc = "Find grep";
          }
          {
            __unkeyed-1 = "<leader>fs";
            __unkeyed-2 = ":ClangdSwitchSourceHeader<CR>";
            desc = "Switch source header";
          }
          {
            __unkeyed-1 = "<leader>/";
            __unkeyed-2 = ''
              <ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>'';
            desc = "Comment";
            mode = [ "n" "v" ];
            icon = "";
          }
        ];
      };
      copilot-lua = {
        suggestion.keymap = {
          accept = "<c-g>";
          next = "<c-y>"; # cycle through suggestions
        };
      };
      cmp.settings.mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
      };
    };

  };
}
