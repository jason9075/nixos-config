{ pkgs, userSettings, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      package = (pkgs.catppuccin-papirus-folders.override { flavor = "mocha"; accent = "sapphire"; });
      name  = "Papirus-Dark";
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
  };
}
