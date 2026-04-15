{ pkgs, ... }:

{
  home.packages = [ pkgs.visidata ];

  home.file.".visidatarc".text = ''
    options.clipboard_copy_cmd = 'wl-copy'
  '';
}
