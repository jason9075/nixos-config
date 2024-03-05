{ pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" ''
    waybar &
    swww init &
    swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep "swaylock -f" &

    sleep 1
  '';
in {

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      timestr = "%R";
      datestr = "%Y / %m / %d";
      fade-in = 0.3;
      grace = 3;
      effect-blur = "20x6";
      indicator= true;
      indicator-radius = 300;
      indicator-thickness = 10;
      indicator-caps-lock = true;
      key-hl-color = "00000066";
      separator-color = "00000000";

      inside-color = "00000033";
      inside-clear-color = "ffffff00";
      inside-caps-lock-color="ffffff00";
      inside-ver-color="ffffff00";
      inside-wrong-color="ffffff00";
      
      ring-color="ffffff";
      ring-clear-color="ffffff";
      ring-caps-lock-color="ffffff";
      ring-ver-color="ffffff";
      ring-wrong-color="ffffff";
      
      line-color="00000000";
      line-clear-color="ffffffFF";
      line-caps-lock-color="ffffffFF";
      line-ver-color="ffffffFF";
      line-wrong-color="ffffffFF";
      
      text-color="ffffff";
      text-clear-color="ffffff";
      text-ver-color="ffffff";
      text-wrong-color="ffffff";
      
      bs-hl-color="ffffff";
      caps-lock-key-hl-color="ffffffFF";
      caps-lock-bs-hl-color="ffffffFF";
      disable-caps-lock-text = true;
      text-caps-lock-color="ffffff";
    };
  };

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
        "$mod, V, togglefloating"
        "$mod, F, exec, rofi -show drun -show-icons"
        "$mod, M, fullscreen"
        "$mod, Q, killactive"
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
      exec-once = ''${startupScript}/bin/start'';
    };
  };
}
