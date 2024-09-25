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
        key = "<leader>e";
        options.silent = true;
        action = ":Neotree reveal toggle<CR>";
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
      # Basic
      {
        mode = "n";
        key = "<leader>/";
        options.silent = true;
        action = '':lua require("Comment.api").toggle.linewise.current()<CR>'';
      }
      {
        mode = "n";
        key = "<leader>q";
        options.silent = true;
        action = ":q<CR>";
      }
      {
        mode = "n";
        key = "<leader>Q";
        options.silent = true;
        action = ":q!<CR>";
      }
      {
        mode = "n";
        key = "<leader>w";
        options.silent = true;
        action = ":w<CR>";
      }
      {
        mode = "n";
        key = "<leader>x";
        options.silent = true;
        action = ":BufDel<CR>";
      }
      {
        mode = "n";
        key = "<leader>m";
        options.silent = true;
        action = ":make<CR>";
      }
      {
        mode = "n";
        key = "<leader>n";
        options.silent = true;
        action = ":Noice dismiss<CR>";
      }
      # Lsp
      {
        mode = "n";
        key = "<leader>l";
        options.silent = true;
        action = ":LspInfo<CR>";
      }
      # Show
      {
        mode = "n";
        key = "<leader>sl";
        options.silent = true;
        action = ":lua vim.diagnostic.open_float()<CR>";
      }
      {
        mode = "n";
        key = "<leader>sh";
        options.silent = true;
        action = ":lua vim.lsp.buf.hover()<CR>";
      }
      # Find
      {
        mode = "n";
        key = "<leader>fD";
        options.silent = true;
        action = ":lua vim.lsp.buf.declaration()<CR>";
      }
      {
        mode = "n";
        key = "<leader>fd";
        options.silent = true;
        action = ":lua vim.lsp.buf.definition()<CR>";
      }
      {
        mode = "n";
        key = "<leader>fe";
        options.silent = true;
        action = ":lua vim.diagnostic.goto_next()<CR>";
      }
      {
        mode = "n";
        key = "<leader>fr";
        options.silent = true;
        action = ":FzfLua lsp_references<CR>";
      }
      {
        mode = "n";
        key = "<leader>ff";
        options.silent = true;
        action = ":FzfLua files<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        options.silent = true;
        action = ":FzfLua live_grep<CR>";
      }
      {
        mode = "n";
        key = "<leader>fs";
        options.silent = true;
        action = ":ClangdSwitchSourceHeader<CR>";
      }
      # Refactor
      {
        mode = "n";
        key = "<leader>rf";
        options.silent = true;
        action = ":Format<CR>";
      }
      {
        mode = "n";
        key = "<leader>rr";
        options.silent = true;
        action = ":lua vim.lsp.buf.rename()<CR>";
      }
      {
        mode = "n";
        key = "<leader>ri";
        options.silent = true;
        action = ":lua require('refactoring').refactor('Inline Variable')<CR>";
      }
      # Visual
      {
        mode = "v";
        key = "<leader>/";
        options.silent = true;
        action = ''
          <ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>'';
      }
    ];
    plugins = {
      which-key = {
        registrations = {
          "<leader>e" = "Toggle file explorer";
          "<S-l>" = "Next buffer";
          "<S-h>" = "Previous buffer";
          "<leader>/" = "Comment";
          "<leader>q" = "Quit";
          "<leader>Q" = "Force quit";
          "<leader>w" = "Save";
          "<leader>x" = "Close buffer";
          "<leader>m" = "Make";
          "<leader>n" = "Noice dismiss";
          "<leader>s" = "Show";
          "<leader>l" = "LspInfo";
          "<leader>sl" = "Show diagnostics";
          "<leader>sh" = "Show hover";
          "<leader>r" = "Refactor";
          "<leader>rf" = "Format";
          "<leader>rr" = "Rename";
          "<leader>ri" = "Inline";
          "<leader>f" = "Find";
          "<leader>fD" = "Find declaration";
          "<leader>fd" = "Find definition";
          "<leader>fe" = "Find next error";
          "<leader>fr" = "Find references";
          "<leader>ff" = "Find files";
          "<leader>fg" = "Find grep";
          "<leader>fs" = "Switch source header";
        };
      };
      copilot-lua = { suggestion.keymap = { accept = "<c-g>"; }; };
      cmp.settings.mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      };
    };

  };
}
