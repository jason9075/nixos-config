{ pkgs, ... }:

let
in {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ms-python.python
      ms-vscode.cpptools
      golang.go
      alefragnani.project-manager
      arcticicestudio.nord-visual-studio-code
      esbenp.prettier-vscode
      editorconfig.editorconfig
      eamodio.gitlens
      vscodevim.vim
      github.copilot
      github.copilot-chat
      yzhang.markdown-all-in-one
      ms-vsliveshare.vsliveshare
      ms-vscode-remote.remote-ssh
    ];

    userSettings = {
      #Color Scheme
      "workbench.colorTheme" = "Nord";
      "editor.renderWhitespace" = "all";
      "editor.renderLineHighlight" = "gutter";

      # Vim Settings
      "vim.useSystemClipboard" = true;
      "vim.smartcase" = true;
      "vim.hlsearch" = true;
      "vim.incsearch" = true;
      "vim.leader" = "<space>"; # leader key

      # Editor Settings
      "editor.tabSize" = 4;
      "editor.insertSpaces" = true;
      "editor.wordWrap" = "off";
      "editor.lineNumbers" = "relative";
      "editor.smoothScrolling" = true;
      "editor.scrollBeyondLastLine" = false;
      "editor.cursorBlinking" = "smooth";
      "editor.formatOnSave" = true;
      "editor.cursorStyle" = "block";
      "editor.minimap.enabled" = false;
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.limit.value" = 2;

      # Vim Keybindings
      "vim.insertModeKeyBindings" = [{
        "before" = [ "k" "j" ];
        "after" = [ "<Esc>" ];
      }];
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          "before" = [ "<leader>" "w" ];
          "commands" = [ "workbench.action.files.save" ];
        }
        {
          "before" = [ "<leader>" "q" ];
          "commands" = [ "workbench.action.closeActiveEditor" ];
        }
        {
          "before" = [ "<S-l>" ];
          "commands" = [ "workbench.action.nextEditor" ];
        }
        {
          "before" = [ "<S-h>" ];
          "commands" = [ "workbench.action.previousEditor" ];
        }
        {
          "before" = [ "<Up>" ];
          "commands" = [ "workbench.action.increaseViewHeight" ];
        }
        {
          "before" = [ "<Down>" ];
          "commands" = [ "workbench.action.decreaseViewHeight" ];
        }
        {
          "before" = [ "<Left>" ];
          "commands" = [ "workbench.action.increaseViewWidth" ];
        }
        {
          "before" = [ "<Right>" ];
          "commands" = [ "workbench.action.decreaseViewWidth" ];
        }
        {
          "before" = [ "<leader>" "f" "d" ];
          "commands" = [ "editor.action.goToDeclaration" ];
        }
        {
          "before" = [ "<leader>" "f" "r" ];
          "commands" = [ "editor.action.referenceSearch.trigger" ];
        }
        {
          "before" = [ "<leader>" "c" ];
          "commands" = [ "editor.action.commentLine" ];
        }
        {
          "before" = [ "<leader>" "e" ];
          "commands" = [ "workbench.action.toggleSidebarVisibility" ];
        }
        {
          "before" = [ "<leader>" "f" "f" ];
          "commands" = [ "workbench.action.quickOpen" ]; # Fuzzy 搜尋檔案標題
        }
        {
          "before" = [ "<leader>" "f" "g" ];
          "commands" = [ "workbench.action.findInFiles" ]; # Fuzzy 搜尋專案內文字
        }

      ];

      # Syntax Highlighting
      "gopls" = { "ui.semanticTokens" = true; };

      # Auto Detect Project and Tree View Settings
      "workbench.autoDetectWorkspace" = true;
      "files.autoReveal" = true;
      "projectManager.autoDetect" = "on";
      "workbench.sideBar.location" = "right";
      "explorer.autoReveal" = true;

      # Copilot Settings
      "github.copilot.suggestion.keymap.accept" = "<c-g>";
      "github.copilot.suggestion.keymap.next" = "<c-y>";

      # Markdown Settings
      "markdown.preview.enabled" = true;
      "markdown.previewFrontMatter" = "show";
      "markdown.preview.breaks" = true;
    };

    # Basic Keybindings
    keybindings = [
      {
        key = "shift+j";
        command = "cursorMove";
        args = {
          to = "down";
          by = "line";
          value = 5;
        };
        when = "editorTextFocus";
      }
      {
        key = "shift+k";
        command = "cursorMove";
        args = {
          to = "up";
          by = "line";
          value = 5;
        };
        when = "editorTextFocus";
      }
    ];
  };

}
