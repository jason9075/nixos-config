{ pkgs, lib, ... }: {
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 8;
      max-visible = 5;
      anchor = "top-right";
      width = 400;
      height = 200;
      font = "Hack 14";
      margin = "8";
      background-color = "#5e81ace0";
      text-color = "#eceff4ff";
    };
  };

  home.packages = with pkgs; [ libnotify ];
}
