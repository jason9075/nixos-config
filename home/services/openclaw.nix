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
    cmake
    
    # 針對本地執行需要的截圖與控制工具
    xdotool
    scrot
  ];
  
  # 2. Configure npm to use local prefix
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = npmGlobalDir;
    PATH = "${npmGlobalDir}/bin:$PATH";
    # Force npm/node-gyp to use system libraries where possible
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.libsecret.dev}/lib/pkgconfig";
  };
  
  # 3. Ensure npm global directory exists
  home.activation = {
    createNpmGlobalDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.coreutils}/bin/mkdir -p ${npmGlobalDir}
    '';
  };
  
  # 4. Write .npmrc to make prefix setting persistent for npm
  home.file.".npmrc".text = ''
    prefix=${npmGlobalDir}
  '';

  # 5. Systemd service using the npm-installed binary
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
      # Disable Nix mode so it behaves like a standard install
      Environment = [ 
        "OPENCLAW_NIX_MODE=0"
        "PATH=${npmGlobalDir}/bin:${pkgs.nodejs}/bin:/run/current-system/sw/bin:/etc/profiles/per-user/${config.home.username}/bin:${pkgs.coreutils}/bin"
        # Ensure native modules can find libraries at runtime
        "LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.openssl.out}/lib"
      ];
      ExecStart = "${npmGlobalDir}/bin/openclaw gateway run";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
