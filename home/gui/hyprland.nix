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

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

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

        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"
        "SHIFT ALT, TAB, cyclenext, prev"
      ];
      # use "hyprctl clients" to show class
      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrulev2 = [
        "workspace 1, class:^(kitty)$"
        "workspace 2, class:^(firefox)$"
        "workspace 2, class:^(brave-browser)$"
        "workspace 3, class:^(Slack)$"
        "workspace 4, class:^(discord)$"
        "workspace 4, class:^(WebCord)$"
        "workspace 5, class:^(thunderbird)$"
        "opacity 0.9 0.7, class:^(thunar)"
      ];
      exec-once = ''${startupScript}/bin/start'';
    };
  };
}
