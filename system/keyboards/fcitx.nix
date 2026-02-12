{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chewing
    ];
  };

  environment.systemPackages = with pkgs; [
    kdePackages.fcitx5-configtool
  ];
}
