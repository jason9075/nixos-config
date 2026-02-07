{ pkgs, inputs, config, lib, ... }:

let
  user = config.home.username;
  # Read tokens at evaluation time (requires --impure)
  gatewayToken = lib.removeSuffix "\n" (builtins.readFile "/home/${user}/.secrets/gateway_token");
  openaiKey = lib.removeSuffix "\n" (builtins.readFile "/home/${user}/.secrets/openai_key");
in {
  imports = [
    inputs.openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;
    documents = ./openclaw/docs;

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
          token = gatewayToken;
        };
      };

      channels.telegram = {
        tokenFile = "/home/${user}/.secrets/telegram_token";
        allowFrom = [ 522953908 ]; 
        groups = {
          "*" = { requireMention = true; };
        };
      };
    };

    instances.default.enable = true;
  };

  # Direct injection into the systemd service environment for OpenAI Key
  systemd.user.services.openclaw-gateway.Service.Environment = [
    "OPENAI_API_KEY=${openaiKey}"
  ];
}
