{ pkgs, ... }:

let
  white = "ffffff";
in {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      timestr = "%R";
      datestr = "%Y / %m / %d";
      fade-in = 0.3;
      grace = 3;
      effect-blur = "20x6";
      indicator= true;
      indicator-radius = 300;
      indicator-thickness = 10;
      indicator-caps-lock = true;
      key-hl-color = "00000066";
      separator-color = "00000000";

      inside-color = "00000033";
      inside-clear-color = "ffffff00";
      inside-caps-lock-color="ffffff00";
      inside-ver-color="ffffff00";
      inside-wrong-color="ffffff00";
      
      ring-color=white;
      ring-clear-color=white;
      ring-caps-lock-color=white;
      ring-ver-color=white;
      ring-wrong-color=white;
      
      line-color="00000000";
      line-clear-color="ffffffFF";
      line-caps-lock-color="ffffffFF";
      line-ver-color="ffffffFF";
      line-wrong-color="ffffffFF";
      
      text-color=white;
      text-clear-color=white;
      text-ver-color=white;
      text-wrong-color=white;
      
      bs-hl-color=white;
      caps-lock-key-hl-color="ffffffFF";
      caps-lock-bs-hl-color="ffffffFF";
      disable-caps-lock-text = true;
      text-caps-lock-color=white;
    };
  };
}
