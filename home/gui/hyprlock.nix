{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
      };

      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 7;
        brightness = 0.8;
      }];

      input-field = [{
        size = "300, 55";
        position = "0, -80";
        halign = "center";
        valign = "center";

        outline_thickness = 3;
        outer_color = "rgb(ffffff)";
        inner_color = "rgba(0, 0, 0, 0.3)";
        font_color = "rgb(ffffff)";

        fade_on_empty = false;
        placeholder_text = "";
        hide_input = false;

        check_color = "rgb(ffffff)";
        fail_color = "rgb(ff6b6b)";
        capslock_color = "rgb(ffffff)";
      }];

      label = [
        # Clock
        {
          text = "$TIME";
          font_size = 80;
          font_family = "Hack Nerd Font";
          color = "rgba(255, 255, 255, 0.9)";
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          text = "cmd[update:60000] date '+%Y / %m / %d'";
          font_size = 20;
          font_family = "Hack Nerd Font";
          color = "rgba(255, 255, 255, 0.7)";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
