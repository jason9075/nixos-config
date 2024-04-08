{ pkgs, userSettings, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      powerline-fonts
      powerline-symbols
      (nerdfonts.override { fonts = [ "Hack" ]; })
      source-han-sans-traditional-chinese
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Source Han Sans TC"];
        sansSerif = ["Source Han Sans TC"];
        monospace = ["Hack Nerd Font Mono"];
      };
    };
  };
}
