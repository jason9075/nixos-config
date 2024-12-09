{ pkgs, ... }:

let stardict = import ./stardict-files.nix { inherit pkgs; };
in {
  home.packages = with pkgs; [
    sdcv # offline dictionary
    ydict # online dictionary
    stardict.files
  ];

  home.file.".stardict/dic".source = "${stardict.files}/share/dictionaries";

  # Alias dict to sdcv
  home.shellAliases = { dict = "sdcv -c"; };

}
