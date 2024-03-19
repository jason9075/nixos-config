{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" ''
    waybar &
    swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep "swaylock -f" &
    swww init &

    sleep 1
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        gaps_in = 2;
        gaps_out = 5;
      };
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };
      "$mod" = "SUPER";
      monitor = ",highres,auto,1";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bind = [
        "$mod, b, exec, brave" # Browser
        ", Print, exec, grimblast copy area"
        "$mod, T, exec, kitty" # term
        "$mod, E, exec, thunar" # file manager
        "$mod, V, togglefloating"
        "$mod, F, exec, rofi -show drun -show-icons"
        "$mod, M, fullscreen"
        "$mod, Q, killactive"
        "$mod, W, exec, ~/nixos-config/scripts/swww_randomize.sh"
        "$mod, X, exec, wlogout"
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

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 10, movetoworkspace, 10"

        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"
        "SHIFT ALT, TAB, cyclenext, prev"
      ];
      # use "hyprctl clients" to show class
      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrulev2 = [
        "workspace 1, class:^(kitty)$"
        "opacity 1.0 0.95, class:^(kitty)$"
        "workspace 2, class:^(firefox)$"
        "workspace 2, class:^(brave-browser)$"
        "workspace 3, class:^(Slack)$"
        "workspace 4, class:^(discord)$"
        "workspace 4, class:^(WebCord)$"
        "workspace 5, class:^(thunderbird)$"
        "opacity 0.9 0.8, class:^(thunar)"
      ];
      exec-once = ''${startupScript}/bin/start'';
    };
  };
}
