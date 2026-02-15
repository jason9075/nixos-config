{ pkgs, ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = "(300, 400)";
        height = 200;
        origin = "top-right";
        offset = "20x20";
        scale = 0;
        notification_limit = 5;

        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        indicate_hidden = "yes";
        transparency = 10;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#88c0d0"; # Nord teal
        
        separator_color = "frame";
        
        sort = "yes";
        idle_threshold = 120;
        
        # Text
        font = "Hack 12";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        
        # Icons
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;
        
        # History
        sticky_history = "yes";
        history_length = 20;
        
        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#2e3440";
        foreground = "#d8dee9";
        timeout = 10;
      };

      urgency_normal = {
        background = "#3b4252";
        foreground = "#eceff4";
        timeout = 10;
      };

      urgency_critical = {
        background = "#bf616a";
        foreground = "#eceff4";
        frame_color = "#bf616a";
        timeout = 0;
      };
    };
  };

  # Ensure libnotify is available for sending notifications
  home.packages = with pkgs; [ libnotify ];
}
