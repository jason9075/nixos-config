{ pkgs, userSettings, ... }:

{
  # Login manager
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command =
          "${pkgs.greetd.tuigreet}/bin/tuigreet --theme time=cyan;greet=border=text=action=blue;prompt=input=green;button=yellow;container=black --time --cmd Hyprland";
        user = userSettings.username;
      };
      # initial_session = {
      #   command = "Hyprland";
      #   user = userSettings.username;
      # };
    };
  };

  # Desktop environment & window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.variables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.variables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  environment.sessionVariables.NIXOS_OZONE_WL =
    "1"; # This variable fixes electron apps in wayland

}
