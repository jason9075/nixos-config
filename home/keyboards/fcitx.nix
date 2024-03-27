{ pkgs, ...}:

{
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ 
    fcitx5-gtk
    fcitx5-chewing 
  ];
}
