{ ... }:

{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        mode = [ "i" "s" ];
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
        mode = [ "n" "v" ];
        key = "<S-j>";
        options.silent = true;
        action = "5<C-e>";
      }
      {
        mode = [ "n" "v" ];
        key = "<S-k>";
        options.silent = true;
        action = "5<C-y>";
      }
      # resize windows with arrow
      {
        mode = "n";
        key = "<Up>";
        action = ":resize +4<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<Down>";
        action = ":resize -4<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<Left>";
        action = ":vertical resize +4<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<Right>";
        action = ":vertical resize -4<CR>";
        options.silent = true;
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
      {
        mode = [ "i" "s" ];
        key = "<C-k>";
        action = "<CMD>lua require('luasnip').expand_or_jump()<CR>";
        options.silent = true;
      }
      {
        mode = [ "i" "s" ];
        key = "<C-j>";
        action = "<CMD>lua require('luasnip').jump(-1)<CR>";
        options.silent = true;
      }
      {
        mode = [ "i" "s" ];
        key = "<C-l>";
        action = "<CMD>lua require('luasnip').change_choice(1)<CR>";
        options.silent = true;
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
            __unkeyed-1 = "<leader>t";
            __unkeyed-2 = ":InspectTree<CR>";
            desc = "Inspect tree";
            icon = "";
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
          # Harpoon
          {
            __unkeyed-1 = "<leader>h";
            group = "Harpoon";
            icon = "󰛢";
          }
          {
            __unkeyed-1 = "<leader>hl";
            __unkeyed-2 = ":lua require('harpoon.ui').toggle_quick_menu()<CR>";
            desc = "List";
            icon = "󰛢";
          }
          {
            __unkeyed-1 = "<leader>ha";
            group = "Add";
            icon = "";
          }
          # Add current file to Harpoon slot 1~4
          {
            __unkeyed-1 = "<leader>ha1";
            __unkeyed-2 =
              "<Cmd>lua require('harpoon.mark').set_current_at(1)<CR>";
            desc = "Slot 1";
            icon = "1";
          }
          {
            __unkeyed-1 = "<leader>ha2";
            __unkeyed-2 =
              "<Cmd>lua require('harpoon.mark').set_current_at(2)<CR>";
            desc = "Slot 2";
            icon = "2";
          }
          {
            __unkeyed-1 = "<leader>ha3";
            __unkeyed-2 =
              "<Cmd>lua require('harpoon.mark').set_current_at(3)<CR>";
            desc = "Slot 3";
            icon = "3";
          }
          {
            __unkeyed-1 = "<leader>ha4";
            __unkeyed-2 =
              "<Cmd>lua require('harpoon.mark').set_current_at(4)<CR>";
            desc = "Slot 4";
            icon = "4";
          }

          # Jump to Harpoon slot 1~4
          {
            __unkeyed-1 = "<leader>h1";
            __unkeyed-2 = "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>";
            desc = "Goto 1";
            icon = "1";
          }
          {
            __unkeyed-1 = "<leader>h2";
            __unkeyed-2 = "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>";
            desc = "Goto 2";
            icon = "2";
          }
          {
            __unkeyed-1 = "<leader>h3";
            __unkeyed-2 = "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>";
            desc = "Goto 3";
            icon = "3";
          }
          {
            __unkeyed-1 = "<leader>h4";
            __unkeyed-2 = "<Cmd>lua require('harpoon.ui').nav_file(4)<CR>";
            desc = "Goto 4";
            icon = "4";
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
            __unkeyed-1 = "<leader>fi";
            __unkeyed-2 = ":FzfLua lsp_implementations<CR>";
            desc = "Find implementations";
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
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-e>" = "cmp.mapping.close()";
        "<C-y>" =
          "cmp.mapping.confirm({ select = true , behavior = cmp.ConfirmBehavior.Insert }, {'i', 'c'})";
        "<C-n>" =
          "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
        "<C-p>" =
          "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
      };
    };

  };
}
