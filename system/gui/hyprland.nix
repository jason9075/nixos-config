{ pkgs, userSettings, lib, ... }:

let
  tuigreetOptions = [
    "--remember"
    "--time"
    # Make sure theme is wrapped in single quotes. See https://github.com/apognu/tuigreet/issues/147
    "--theme 'greet=border=text=action=white;time=lightcyan;prompt=input=green;button=yellow;container=gray'"
    "--cmd Hyprland"
  ];
  flags = lib.concatStringsSep " " tuigreetOptions;

in {
  # Login manager
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet ${flags}";
        user = userSettings.username;
      };
    };
  };

  # Desktop environment & window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.variables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.variables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # This variable fixes electron apps in wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

}
