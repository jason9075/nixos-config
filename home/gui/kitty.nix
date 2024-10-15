{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Hack";
      size = 14;
    };
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
    keybindings = {
      # window
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";

      # scroll up/down
      "ctrl+u" = "scroll_page_up";
      "ctrl+d" = "scroll_page_down";

      # change font size
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
    };
    extraConfig = ''
      # to avoid typing special character in MacOS
      macos_option_as_alt yes

      # Nightfox colors for Kitty
      ## name: nordfox
      ## upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/nordfox/kitty.conf

      background #2e3440
      foreground #cdcecf
      selection_background #3e4a5b
      selection_foreground #cdcecf
      url_color #a3be8c
      cursor #cdcecf

      # Tabs
      active_tab_background #81a1c1
      active_tab_foreground #232831
      inactive_tab_background #3e4a5b
      inactive_tab_foreground #60728a

      # normal
      color0 #3b4252
      color1 #bf616a
      color2 #a3be8c
      color3 #ebcb8b
      color4 #81a1c1
      color5 #b48ead
      color6 #88c0d0
      color7 #e5e9f0

      # bright
      color8 #465780
      color9 #d06f79
      color10 #b1d196
      color11 #f0d399
      color12 #8cafd2
      color13 #c895bf
      color14 #93ccdc
      color15 #e7ecf4

      # extended colors
      color16 #c9826b
      color17 #bf88bc
    '';
  };
}
