{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" ''
    waybar &
    swayidle -w timeout 600 'swaylock -f' timeout 900 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep "swaylock -f" &
    swww init &
    pypr &
    $HOME/nixos-config/scripts/swww_randomize.sh

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
      monitor = [ "HDMI-A-1,1920x1080@60,0x0,1" ];
      bindm = [
        "$mod, mouse:272, movewindow                                    # Move window"
        "$mod, mouse:273, resizewindow                                  # Resize window"
        "$mod ALT, mouse:272, resizewindow                              # Resize window"
      ];
      bind = [
        "$mod, A, exec, ~/nixos-config/scripts/rofi_keybindings.sh      # Show all keybinding"
        "$mod, F, exec, rofi -show drun -show-icons                     # Application launcher"
        "$mod, T, exec, kitty                                           # Terminal"
        "$mod, B, exec, brave                                           # Brave web browser"
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
        "workspace 9, class:^(firefox)$"
        "workspace 9, class:^(brave-browser)$"
        "workspace 8, class:^(Slack)$"
        "workspace 7, class:^(discord)$"
        "workspace 7, class:^(WebCord)$"
        "workspace 6, class:^(thunderbird)$"
        "opacity 1.0 0.93, class:^(kitty)$"
        "opacity 1.0 0.93, class:^.*zathura$"
        "opacity 0.95 0.88, class:^(thunar)$"
      ];
      bezier = "myBeizer, 0.05, 0.9, 0.1, 1.05";
      animation = [ "windows, 1, 8, myBeizer" ];
      exec-once = "${startupScript}/bin/start";
    };
  };

  # https://github.com/hyprland-community/pyprland/wiki/scratchpads
  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = ["scratchpads"]

    [scratchpads.chatgpt]
    animation = "fromtop"
    command = "firefox --name=chatgpt_app --no-remote -P chatgpt https://chat.openai.com"
    class = "chatgpt_app"
    size = "80% 85%"
    margin = 50
    lazy = true

    [scratchpads.term]
    animation = "fromtop"
    command = "kitty --class term"
    class = "term"
    size = "80% 85%"
    margin = 50
  '';
}
