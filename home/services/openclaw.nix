{ pkgs, inputs, config, lib, ... }:

let
  user = config.home.username;
in {
  imports = [
    inputs.openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;
    # documents = ./openclaw/docs;

    config = {
      agents.defaults = {
        model.primary = "openai/gpt-5.2";
        models."openai/gpt-5.2".alias = "gpt";
      };

      messages.ackReactionScope = "group-mentions";

      gateway = {
        mode = "local";
        port = 18789;
        bind = "loopback";
        auth = {
          mode = "token";
        };
      };
    };

    instances.default.enable = true;
  };
  
  # Ensure the service starts with the graphical session
  systemd.user.services.openclaw-gateway.Install.WantedBy = lib.mkForce [ "graphical-session.target" ];

}
