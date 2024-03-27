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
        gaps_in = 2;
        gaps_out = 5;
      };
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };
      monitor = ",highres,auto,1";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bind = [
        ", Print, exec, grim -g \"\$(slurp)\""
        "$mod, Print, exec, grim -g - \"\$(slurp)\" | swappy -f -"
        "$mod, B, exec, brave" # Browser
        "$mod, T, exec, kitty" # term
        "$mod, E, exec, thunar" # file manager
        "$mod, V, togglefloating"
        "$mod, F, exec, rofi -show drun -show-icons"
        "$mod, M, fullscreen"
        "$mod, Q, killactive"
        "$mod, W, exec, ~/nixos-config/scripts/swww_randomize.sh"
        "$mod, X, exec, wlogout"
        "$mod SHIFT, E, exec, rofi -show emoji"
        "$mod SHIFT, C, exec, rofi -show calc -no-show-match -no-sort"
        "$mod, equal,  exec, pactl -- set-sink-volume 0 +10%"
        "$mod, minus, exec, pactl -- set-sink-volume 0 -10%"
        "$mod, left,  resizeactive, -80 0"
        "$mod, right, resizeactive, 80 0"
        "$mod, up,    resizeactive, 0 -80"
        "$mod, down,  resizeactive, 0 80"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        # Scratchpads
        "$mod, C, exec, pypr toggle chatgpt"
        "$mod, I, exec, pypr toggle term"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"
        "SHIFT ALT, TAB, cyclenext, prev"
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
        "opacity 1.0 0.95, class:^(kitty)$"
        "opacity 0.95 0.88, class:^(thunar)$"
      ];
      bezier = "myBeizer, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 8, myBeizer"
      ];
      exec-once = ''${startupScript}/bin/start'';
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
