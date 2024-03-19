{ pkgs, userSettings, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      package = (pkgs.catppuccin-papirus-folders.override { flavor = "mocha"; accent = "sky"; });
      name  = "Papirus-Dark";
    };
    theme = {
      package = (pkgs.catppuccin-gtk.override { accents = [ "sky" ]; size = "standard"; variant = "mocha"; });
      name = "Catppuccin-Mocha-Standard-Sky-Dark";
    };
  };
}
