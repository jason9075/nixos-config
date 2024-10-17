{ pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      package = (pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "sapphire";
      });
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    cursorTheme = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
    };
  };
}
