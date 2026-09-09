{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  agsPackages = inputs.ags.packages.${system};
  pythonPackages = pkgs.python3Packages;

  aiUsageCli = pythonPackages.buildPythonApplication rec {
    pname = "ai-usage-cli";
    version = "0.1.1";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "jason9075";
      repo = "ai-usage-cli";
      rev = "0e2503b1244d7c51f1eb8ee9e00cbe5f3c972262";
      hash = "sha256-feuG4OyrBH++8iR7SWXL69MdHrLm1RsWJZneRfYv5Ek=";
    };

    build-system = [ pythonPackages.hatchling ];
    dependencies = with pythonPackages; [
      dbus-fast
      httpx
      rich
      secretstorage
      truststore
    ];

    # dbus-fast 4 provides every API used by the tray daemon. PyQt5 is listed
    # upstream but is not imported by either the CLI or its DBus tray service.
    pythonRelaxDeps = [ "dbus-fast" ];
    pythonRemoveDeps = [ "pyqt5" ];

    postPatch = ''
      substituteInPlace ai_usage/tray.py \
        --replace-fail '["xclip", "-selection", "clipboard"]' '["wl-copy"]' \
        --replace-fail 'os.path.expanduser("~/.local/share/icons/ai-usage.png")' '"ai-usage"'
    '';

    postInstall = ''
      install -Dm644 assets/ai-usage.png \
        $out/share/icons/hicolor/512x512/apps/ai-usage.png
    '';

    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (pkgs.lib.makeBinPath [ pkgs.libnotify pkgs.wl-clipboard pkgs.xdg-utils ])
    ];

    pythonImportsCheck = [ "ai_usage" ];
  };
in {
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ./ags;
    systemd.enable = true;

    # The AGS module already includes the core Astal GTK and IO libraries.
    # These are the additional integrations used by Taipei's bar.
    extraPackages = [
      agsPackages.hyprland
      agsPackages.tray
      agsPackages.wireplumber
      aiUsageCli
      pkgs.bash
      pkgs.coreutils
      pkgs.swaynotificationcenter
    ];
  };

  home.packages = [ aiUsageCli ];
}
