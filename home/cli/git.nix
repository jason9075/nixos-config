{ pkgs, userSettings...}:

{
  programs.git = {
    enable = true;
    userName = userSettings.userName;
    userEmail = userSettings.userName + "@users.noreply.github.com";
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
    };
  };
}
