{ pkgs, userSettings, ... }:

{
  services = {
    mpdris2.enable = false; # nix 25.11 breaks it
    mpd = {
      enable = true;
      musicDirectory = "/home" + ("/" + userSettings.username) + "/Music";
      network.startWhenNeeded = true;
      extraConfig = ''
        audio_output {
          type    "alsa"
          name    "Sound Server"
        }
      '';
    };
  };

  home.packages = with pkgs; [ mpd cava ffmpeg mpc-cli ];

  programs = {
    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
      bindings = [
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "h";
          command = "previous_column";
        }
        {
          key = "l";
          command = "next_column";
        }
      ];
      settings = {
        "colors_enabled" = "yes";
        "playlist_editor_display_mode" = "columns";
        "playlist_display_mode" = "columns";
        "search_engine_display_mode" = "columns";
        "user_interface" = "alternative";
        "main_window_color" = "magenta";
        "progressbar_color" = "white";
        "current_item_prefix" = "$(cyan)$r";
        "current_item_suffix" = "$/r$(end)";
        "current_item_inactive_column_prefix" = "$(magenta)$r";
        "volume_color" = "green";
        "progressbar_elapsed_color" = "cyan";
      };
    };
  };
}
