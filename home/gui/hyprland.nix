{ inputs, lib, config, pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" ''
    sleep 3
    nm-applet &
    mako &
    swayidle -w timeout 600 'swaylock -f' timeout 900 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep "swaylock -f" &
    echo "swww init"
    eww daemon
    swww-daemon --format xrgb &
    pypr &
    sleep 1
    ${lib.optionalString config.eww_config.widgets.enable "eww open widgets"}
    ${lib.optionalString config.eww_config.pomodoro.enable "eww open pomodoro"}
    $HOME/nixos-config/scripts/swww_randomize.sh
    $HOME/nixos-config/scripts/check_firefox_profile.sh chatgpt
    $HOME/nixos-config/scripts/check_firefox_profile.sh calendar
  '';
in {

  imports = [ ./eww.nix ];

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
        shadow.offset = "4 4";
        shadow.color = "rgba(00000099)";
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
        "$mod, W, exec, /home/jason9075/projects/wkey/wkey              # wkey"
        "$mod SHIFT, W, exec, ~/nixos-config/scripts/swww_randomize.sh  # Randomize wallpaper"
        "$mod, B, exec, pkill -USR1 waybar                              # Toggle waybar"
        "$mod, equal,  exec, pactl -- set-sink-volume 0 +10%            # Volume up"
        "$mod, minus, exec, pactl -- set-sink-volume 0 -10%             # Volume down"
        ''
          , Print, exec, grim -g "$(slurp)"                             # Screenshot''
        ''
          $mod, Print, exec, grim - | wl-copy                           # Screenshot with edit''
        "$mod, left,  movewindow, l                                     # Move window left"
        "$mod, right, movewindow, r                                     # Move window right"
        "$mod, up,    movewindow, u                                     # Move window up"
        "$mod, down,  movewindow, d                                     # Move window down"
        "$mod CTRL, H, movewindow, l                                    # Move window left"
        "$mod CTRL, L, movewindow, r                                    # Move window right"
        "$mod CTRL, K, movewindow, u                                    # Move window up"
        "$mod CTRL, J, movewindow, d                                    # Move window down"
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
        "$mod, C, exec, pypr toggle chat_ai                             # AI chat browser scratchpad"
        "$mod, P, exec, pypr toggle calendar                            # Calendar scratchpad"
        "$mod, I, exec, pypr toggle htop                                # htop scratchpad"
        "$mod, N, exec, pypr toggle nvtop                               # nvtop scratchpad"
        "$mod, O, exec, pypr toggle kitty                               # kitty scratchpad"
        "$mod, Y, exec, pypr toggle yazi                                # yazi scratchpad"

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
      windowrule = [
        "float on, match:class ^(chat_ai_app)$"
        "float on, match:class ^(calendar_app)$"
        "float on, match:class ^(htop)$"
        "float on, match:class ^(nvtop)$"
        "float on, match:class ^(code_pane)$"
        "float on, match:class ^(yazi)$"
        "size (monitor_w*0.80) (monitor_h*0.85), match:class ^(chat_ai_app)$"
        "size (monitor_w*0.80) (monitor_h*0.85), match:class ^(calendar_app)$"
        "workspace 10, match:class ^(kitty)$"
        "workspace 10, match:class ^(code-url-handler)$" # vscode url handler
        # "workspace 9, match:class ^(.*qutebrowser)$"
        "workspace 9, match:class ^(firefox)$"
        "workspace 9, match:class ^(brave-browser)$"
        "workspace 8, match:class ^(Slack)$"
        "workspace 7, match:class ^(discord)$"
        "workspace 7, match:class ^(WebCord)$"
        "workspace 6, match:class ^(thunderbird)$"
        "opacity 1.0 0.9, match:class ^(kitty)$"
        "opacity 1.0 0.9, match:class ^(code-url-handler)$"
        "opacity 1.0 0.93, match:class ^.*zathura$"
        "opacity 0.95 0.88, match:class ^(thunar)$"
        "opacity 0.9 0.7, match:class ^(htop)$"
        "opacity 0.9 0.7, match:class ^(nvtop)$"
        "idle_inhibit fullscreen, fullscreen 1"
      ];
      workspace = [
        "10, name:coding, gapsin:0, gapsout:0"
        "9, name:browser"
        "8, name:slack"
        "7, name:discord"
      ];
      bezier = "myBeizer, 0.05, 0.9, 0.1, 1.05";
      animation =
        [ "windows, 1, 8, myBeizer" "workspaces, 1, 8, myBeizer, fade" ];
      exec-once = "${startupScript}/bin/start";
    };
  };

  # # https://hyprland-community.github.io/pyprland/scratchpads.html
  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = ["scratchpads"]

    [scratchpads.chat_ai]
    command = "firefox --name=chat_ai_app --no-remote -P chatgpt https://gemini.google.com"
    class = "chat_ai_app"
    # size = "80% 85%"

    [scratchpads.calendar]
    animation = "fromLeft"
    command = "firefox --name=calendar_app --no-remote -P calendar https://calendar.google.com/calendar"
    class = "calendar_app"
    size = "80% 85%"
    lazy = true

    [scratchpads.htop]
    animation = "fromRight"
    command = "kitty --class htop --hold htop"
    class = "htop"
    size = "80% 85%"
    margin = 50
    lazy = true

    [scratchpads.nvtop]
    animation = "fromBottom"
    command = "kitty --class nvtop --hold nvtop"
    class = "nvtop"
    size = "80% 85%"
    margin = 50
    lazy = true
    
    [scratchpads.kitty]
    command = "kitty --class code_pane --hold"
    class = "code_pane"
    size = "90% 90%"
    lazy = true

    [scratchpads.yazi]
    animation = "fromTop"
    command = "kitty --class yazi yazi"
    class = "yazi"
    size = "80% 90%"
    lazy = true

  '';

  home.packages = with pkgs; [ hyprpicker networkmanagerapplet inputs.hyprshutdown.packages.${pkgs.system}.default];
}
