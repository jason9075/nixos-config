{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [ "one-dark-theme" ];
    userSettings = {
      theme = "One Dark";
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;
      autosave = "on_focus_change";
      tab_size = 2;
      buffer_font_family = "Hack";
      terminal = {
        font_family = "Hack";
        font_size = 14;
      };
    };
    userKeymaps = [
      {
        context = "Editor && vim_mode == insert";
        bindings = {
          "k j" = "vim::NormalBefore";
        };
      }
      {
        context = "VimControl && !menu";
        bindings = {
          # Tab navigation
          "shift-h" = "pane::ActivatePrevItem";
          "shift-l" = "pane::ActivateNextItem";

          # Fast scroll (Mapped from 5<C-e> / 5<C-y>)
          "shift-j" = [ "workspace::SendKeystrokes" "5 j" ];
          "shift-k" = [ "workspace::SendKeystrokes" "5 k" ];

          # Leader mappings
          "space e" = "workspace::ToggleLeftDock";
          "space w" = "workspace::Save";
          "space q" = "pane::CloseActiveItem";
          "space x" = "pane::CloseActiveItem";
          "space /" = "editor::ToggleComments";

          # Finder / Search
          "space f f" = "file_finder::Toggle";
          "space f g" = "pane::DeploySearch";

          # LSP
          "space f d" = "editor::GoToDefinition";
          "space r r" = "editor::Rename";
          "space r a" = "editor::ToggleCodeActions";
          "space s l" = "editor::GoToDiagnostic";

          # Resize panes
          "up" = "vim::ResizePaneUp";
          "down" = "vim::ResizePaneDown";
          "left" = "vim::ResizePaneLeft";
          "right" = "vim::ResizePaneRight";
        };
      }
    ];
  };
}
