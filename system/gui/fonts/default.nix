{ pkgs, ... }:

let elffont = import ./elffont.nix { inherit pkgs; };
in {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      powerline-fonts
      powerline-symbols
      nerd-fonts.hack
      source-han-sans-traditional-chinese
      elffont.v1
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Source Han Sans TC" ];
        sansSerif = [ "Source Han Sans TC" ];
        monospace = [ "Hack Nerd Font Mono" ];
      };
    };
  };
}
