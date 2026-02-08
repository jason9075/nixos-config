{ pkgs, config, lib, ... }:

let
  npmGlobalDir = "${config.home.homeDirectory}/.npm-global";
in {
  # 1. Provide build tools for native npm modules
  home.packages = with pkgs; [
    nodejs
    python3
    gnumake
    gcc
    pkg-config
    libsecret
  ];
  
  # 2. Configure npm to use local prefix
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = npmGlobalDir;
    PATH = "${npmGlobalDir}/bin:$PATH";
  };
  
  # 3. Ensure npm global directory exists
  home.activation = {
    createNpmGlobalDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.coreutils}/bin/mkdir -p ${npmGlobalDir}
    '';
  };

  # 4. Systemd service using the npm-installed binary
  systemd.user.services.openclaw-gateway = {
    Unit = {
      Description = "OpenClaw Gateway (NPM)";
      After = [ "graphical-session.target" "network.target" ];
      # Only start if the npm package is actually installed
      ConditionFileIsExecutable = "${npmGlobalDir}/bin/openclaw";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Environment = [
        "OPENCLAW_NIX_MODE=0"
        "PATH=${npmGlobalDir}/bin:/run/current-system/sw/bin:/etc/profiles/per-user/${config.home.username}/bin:${pkgs.coreutils}/bin"
      ];
      ExecStart = "${npmGlobalDir}/bin/openclaw gateway run";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
