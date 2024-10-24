{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" ''
    waybar &
    swayidle -w timeout 600 'swaylock -f' timeout 900 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep "swaylock -f" &
    echo "swww init"
    eww daemon &
    eww open widgets
    swww-daemon --format xrgb &
    pypr &
    $HOME/nixos-config/scripts/swww_randomize.sh
    $HOME/nixos-config/scripts/check_firefox_profile.sh chatgpt
    $HOME/nixos-config/scripts/check_firefox_profile.sh calendar

    sleep 1
  '';
in {

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      general = {
        gaps_in = 4; # space between windows
        gaps_out = "4,12,12,12"; # speace to monitor (top, right, bottom, left)
        border_size = 2; # focus border
        "col.active_border" = "rgba(ECEFF4EE)"; # focus border color
        layout = "master";
      };
      decoration = {
        rounding = 4;
        shadow_offset = "4 4";
        "col.shadow" = "rgba(00000099)";
      };
      # check settings here https://wiki.hyprland.org/Configuring/Master-Layout/
      master = {
        new_status = "slave";
        new_on_top = false;
        mfact = 0.7;
      };
      monitor = [ "HDMI-A-1,1920x1080@144,0x0,1" ];
      # git clone https://github.com/guillaumeboehm/Nordzy-cursors.git /tmp/cursor
      # cp -r /tmp/cursor/hyprcursors/themes/Nordzy-hyprcursors ~/.icons/
      env = [ "HYPRCURSOR_THEME, Nordzy-hyprcursors" "HYPRCURSOR_SIZE, 24" ];
      bindm = [
        "$mod, mouse:272, movewindow                                    # Move window"
        "$mod, mouse:273, resizewindow                                  # Resize window"
        "$mod ALT, mouse:272, resizewindow                              # Resize window"
      ];
      bind = [
        "$mod, A, exec, ~/nixos-config/scripts/rofi_keybindings.sh      # Show all keybinding"
        "$mod, F, exec, rofi -show drun -show-icons                     # Application launcher"
        "$mod, T, exec, kitty                                           # Terminal"
        "$mod, E, exec, thunar                                          # File Manager"
        "$mod, X, exec, wlogout                                         # Power menu"
        "$mod, Q, killactive                                            # Close window"
        "$mod, M, fullscreen                                            # Toggle fullscreen"
        "$mod, V, togglefloating                                        # Toggle floating"
        "$mod, W, exec, ~/nixos-config/scripts/swww_randomize.sh        # Randomize wallpaper"
        "$mod, equal,  exec, pactl -- set-sink-volume 0 +10%            # Volume up"
        "$mod, minus, exec, pactl -- set-sink-volume 0 -10%             # Volume down"
        ''
          , Print, exec, grim -g "$(slurp)"                             # Screenshot''
        ''
          $mod, Print, exec, grim -g - "$(slurp)" | swappy -f -         # Screenshot with edit''
        "$mod, left,  movewindow, l                                     # Move window left"
        "$mod, right, movewindow, r                                     # Move window right"
        "$mod, up,    movewindow, u                                     # Move window up"
        "$mod, down,  movewindow, d                                     # Move window down"
        "$mod SHIFT, bracketleft, movewindow, l                         # Move window left"
        "$mod SHIFT, bracketright, movewindow, r                        # Move window right"
        "$mod, H, movefocus, l                                          # Focus left"
        "$mod, L, movefocus, r                                          # Focus right"
        "$mod, K, movefocus, u                                          # Focus up"
        "$mod, J, movefocus, d                                          # Focus down"
        "$mod SHIFT, H, resizeactive, -80 0                             # Resize window left"
        "$mod SHIFT, L, resizeactive, 80 0                              # Resize window right"
        "$mod SHIFT, K, resizeactive, 0 -80                             # Resize window up"
        "$mod SHIFT, J, resizeactive, 0 80                              # Resize window down"
        # Scratchpads
        "$mod, C, exec, pypr toggle chatgpt                             # ChatGPT scratchpad"
        "$mod, P, exec, pypr toggle calendar                            # Calendar scratchpad"
        "$mod, I, exec, pypr toggle term                                # Terminal scratchpad"

        "$mod, 1, workspace, 1                                          # Switch to workspace 1"
        "$mod, 2, workspace, 2                                          # Switch to workspace 2"
        "$mod, 3, workspace, 3                                          # Switch to workspace 3"
        "$mod, 4, workspace, 4                                          # Switch to workspace 4"
        "$mod, 5, workspace, 5                                          # Switch to workspace 5"
        "$mod, 6, workspace, 6                                          # Switch to workspace 6"
        "$mod, 7, workspace, 7                                          # Switch to workspace 7"
        "$mod, 8, workspace, 8                                          # Switch to workspace 8"
        "$mod, 9, workspace, 9                                          # Switch to workspace 9"
        "$mod, 0, workspace, 10                                         # Switch to workspace 10"
        "$mod SHIFT, 1, movetoworkspace, 1                              # Move window to workspace 1"
        "$mod SHIFT, 2, movetoworkspace, 2                              # Move window to workspace 2"
        "$mod SHIFT, 3, movetoworkspace, 3                              # Move window to workspace 3"
        "$mod SHIFT, 4, movetoworkspace, 4                              # Move window to workspace 4"
        "$mod SHIFT, 5, movetoworkspace, 5                              # Move window to workspace 5"
        "$mod SHIFT, 6, movetoworkspace, 6                              # Move window to workspace 6"
        "$mod SHIFT, 7, movetoworkspace, 7                              # Move window to workspace 7"
        "$mod SHIFT, 8, movetoworkspace, 8                              # Move window to workspace 8"
        "$mod SHIFT, 9, movetoworkspace, 9                              # Move window to workspace 9"
        "$mod SHIFT, 0, movetoworkspace, 10                             # Move window to workspace 10"

        "$mod, bracketright, workspace, +1                              # Switch to next workspace"
        "$mod, bracketleft, workspace, -1                               # Switch to previous workspace"

        "ALT, TAB, cyclenext                                            # Cycle through windows"
        "ALT, TAB, bringactivetotop                                     # Bring window to top"
        "SHIFT ALT, TAB, cyclenext, prev                                # Cycle through windows backwards"
      ];
      # use "hyprctl clients" to show class
      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrulev2 = [
        "workspace 10, class:^(kitty)$"
        "workspace 9, class:^(.*qutebrowser)$"
        "workspace 9, class:^(firefox)$"
        "workspace 9, class:^(brave-browser)$"
        "workspace 8, class:^(Slack)$"
        "workspace 7, class:^(discord)$"
        "workspace 7, class:^(WebCord)$"
        "workspace 6, class:^(thunderbird)$"
        "opacity 1.0 0.9, class:^(kitty)$"
        "opacity 1.0 0.93, class:^.*zathura$"
        "opacity 0.95 0.88, class:^(thunar)$"
      ];
      bezier = "myBeizer, 0.05, 0.9, 0.1, 1.05";
      animation =
        [ "windows, 1, 8, myBeizer" "workspaces, 1, 8, myBeizer, fade" ];
      exec-once = "${startupScript}/bin/start";
    };
  };

  # # https://github.com/hyprland-community/pyprland/wiki/scratchpads
  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = ["scratchpads"]

    [scratchpads.chatgpt]
    animation = "fromTop"
    command = "firefox --name=chatgpt_app --no-remote -P chatgpt https://chat.openai.com"
    class = "chatgpt_app"
    size = "80% 85%"
    margin = 50
    lazy = true

    [scratchpads.calendar]
    animation = "fromLeft"
    command = "firefox --name=calendar_app --no-remote -P calendar https://calendar.google.com/calendar"
    class = "calendar_app"
    size = "80% 85%"
    margin = 50
    lazy = true

    [scratchpads.term]
    animation = "fromRight"
    command = "kitty --class term --hold htop"
    class = "term"
    size = "80% 85%"
    margin = 50
    lazy = true
  '';

  # eww
  home.file.".config/eww/eww.yuck".text = ''
    ;; CAL VARS
    (defpoll calendar_day :interval "10h" "date '+%d'")
    (defpoll calendar_year :interval "10h" "date '+%Y'")
    (defpoll calendar_date :interval "12h" "date '+%A, %d %B'")
    (defpoll today :interval "12h" "date '+%a, %d %B'")
    (defpoll time :interval "5s" "date '+%H:%M'")

    ;; ENV VARS
    (defpoll UPTIME :interval "1m" "$HOME/nixos-config/scripts/uptime.sh &")
    (defpoll IP_ADDR :interval "24h" "ip -br address | grep UP | awk '{ print $3 }'")
    (defpoll NET_INTERFACE :interval "24h" "ip -br address | grep UP | awk '{ print $1}'")

    ;; Widgets

    (defwidget dash []
      (box :class "dash" :orientation "h")
    )

    (defwidget cal []
      (box :class "cal-container" :orientation "v" :space-evenly "false" :halign "center"
        (box :class "cal-box" :orientation "v" :space-evenly "false"
          (label :class "clock" :text time)
          (label :class "date" :text today)
        )
        (box :class "cal-window" :orientation "h"
          (calendar :class "day-names month-year"
                    :day calendar_day
                    :year calendar_year
                    :orientation "v")
        )
      )
    )

    (defwidget info []
      (box :class "info-box-outer" :orientation "h" :space-evenly false :halign "center"
        (box :class "info-box-top" :orientation "v" :space-evenly false
          (box :class "info-box-inner" :orientation "h" :space-evenly false
            (box :class "info-box-left" :orientation "v" :space-evenly false
              (label :class "info-icon" :text " :")
            )
            (box :class "info-box-right" :orientation "v" :space-evenly false
              (label :class "info-text" :halign "start" :text "''${UPTIME}")
            )
          )
        )
      )
    )

    (defwidget network []
      (box :class "network-label" :orientation "h" :space-evenly "false" :spacing 10 :halign "center"
        (label :text "IP ''${IP_ADDR}")
      )
    )

    (defwidget network-up []
      (box :class "network" :orientation "h" :space-evenly "false" :spacing 10 :halign "center"
        (box :orientation "h" :class "network-box"
          (label :text "" :class "network-up")
        )
        (box :orientation "h" :width 100
          (graph :class "network-graph-up"
                 :thickness 2
                 :value {round(EWW_NET[NET_INTERFACE].NET_UP / 1000, 1)}
                 :time-range "2m"
                 :min 0
                 :max 101
                 :dynamic "true"
                 :line-style "round")
        )
      )
    )

    (defwidget network-down []
      (box :class "network" :orientation "h" :space-evenly "false" :spacing 10 :halign "center"
        (box :orientation "h" :class "network-box"
          (label :text "" :width 10 :class "network-down")
        )
        (box :orientation "h" :width 100
          (graph :class "network-graph-down"
                 :thickness 2
                 :value {round(EWW_NET[NET_INTERFACE].NET_DOWN, 1)}
                 :time-range "2m"
                 :min 0
                 :max 101
                 :dynamic "true"
                 :line-style "round")
        )
      )
    )

    (defwidget right []
      (box :class "right" :orientation "v" :space-evenly "false"
        (cal)
        (dash)
        (network)
        (network-up)
        (network-down)
        (info)
      )
    )

    (defwindow widgets
      :monitor 0
      :geometry (geometry :x "16px"
                          :y "40px"
                          :width "180px"
                          :height "0%"
                          :anchor "top right")
      :stacking "bg"
      :windowtype "dock"
      :exclusive false
      (box :class "main-container"
        (right)
      )
    )
  '';

  home.file.".config/eww/eww.scss".text = ''

    // GENERAL STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    * {
      all: unset;
      font-family: Hack Nerd Font;
      font-size: 14px;
    }

    $white: #f8fbfc;
    $lightgray: #dfe2e3;
    $gray: #c5c8c9;
    $medgray: #797c7d;
    $darkgray: #46494a;
    $black: #1a1b26;

    $color1: #bf616a;
    $color2: #eba0ac;
    $color3: #d08770;
    $color4: #ebcb8b;
    $color5: #b48ead; // purple
    $color6: #e9bdbd;
    $color7: #f5e0dc;
    $color8: #a3be8c;
    $color9: #a3be8c;
    $color10: #8fbcbb;
    $color11: #b48ead;
    $color12: #b48ead;
    $color13: #b48ead;
    $color14: #b48ead;
    $color15: #4e40d4;
    $color16: #5e81ac;
    $color17: #81a1c1; // blue
    $color18: #88c0d0; // cyan
    $color19: #d6ffff;
    $color20: #2e3440;
    $color21: #0d0e19;
    $color22: rgba(13, 14, 25, 0.5);
    $color23: rgba(46, 52, 64, 0.7);
    $color24: rgba(36, 40, 59, 0.5);
    $color25: rgba(13, 14, 25, 0.2);
    $color26: rgba(26, 27, 38, 0.2);

    .main-container {
      background-color: $color23;
      border-radius: 14px;
      margin: 0px 8px 8px 0px;
      box-shadow: 1px 1px 3px 1px #151515;
    }

    .dash {
      background-color: rgba(20, 22, 30, 0.6);
      margin: 4px 16px 2px 16px;
      padding: 2px;
    }
    .info-box-left {
      padding: 4px;
    }
    .info-box-right {
      padding: 4px;
    }
    .info-icon {
      color: $color14;
    }
    .info-text {
      color: $color19;
    }

    .network {
      padding: 5px 0px 5px 0px;
    }
    .network-label {
      color: $color18;
      font-size: 16px;
      font-weight: bold;
      padding: 10px 0px 4px 0px;
    }
    .network-up {
      color: $color14;
      font-size: 20px;
    }
    .network-down {
      color: $color17;
      font-size: 20px;
    }
    .network-graph-up {
      color: $color14;
      padding: 10px;
      background-color: rgba(203, 166, 247, 0.2);
    }
    .network-graph-down {
      color: $color17;
      padding-bottom: 10px;
      background-color: rgba(122, 162, 247, 0.2);
    }

    // CALENDAR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .cal-container {
      border-radius: 10px;
    }
    .cal-box {
      border-radius: 10px;
    }
    .cal-window {
      border-radius: 10px;
      padding-top: 10px;
    }
    .month-year {
      font-size: 12px;
      font-weight: bold;
      margin: 10px;
      padding: 1px;
      color: $lightgray;
    }
    .day-names {
      margin: 10px;
      font-size: 12px;
      font-weight: bold;
      color: $color10;
    }
    .date {
      color: $color17;
      font-size: 14px;
      font-weight: bold;
      border-radius: 10px;
    }

    .clock {
      font-size: 38px;
      font-weight: bold;
      color: $color13;
      border-radius: 10px;
      padding-top: 6px;
    }

    calendar {
      &:selected {
        color: $color9;
      }
      &:indeterminate {
        color: rgba(205, 219, 249, 0.3);
      }
    }
    calendar.button {
      color: $gray;
    }
    calendar.highlight {
      color: $color18;
      font-weight: bold;
      padding: 10px;
      margin: 10px;
    }
  '';

  home.packages = with pkgs; [ hyprpicker eww ];
}
