{ pkgs, lib, ... }: {
  services.mako = {
    enable = true;
    settings = {
      defaultTimeout = 5000;
      borderRadius = 8;
      maxVisible = 5;
      anchor = "top-right";
      width = 400;
      height = 200;
      font = "Hack 14";
      margin = "8";
      backgroundColor = "#5e81ace0";
      textColor = "#eceff4ff";
    };
  };

  home.packages = with pkgs; [ libnotify ];
}
