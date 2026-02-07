{ pkgs, inputs, config, lib, ... }:

let
  user = config.home.username;
in {
  imports = [
    inputs.openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;
    instances.default.enable = true;
  };
  
  # Ensure the service starts with the graphical session
  systemd.user.services.openclaw-gateway.Install.WantedBy = lib.mkForce [ "graphical-session.target" ];

}
