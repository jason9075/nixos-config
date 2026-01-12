{ userSettings, ... }:

{
  programs.git = {
    enable = true;
    userName = userSettings.username;
    userEmail = userSettings.email;
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
    };
    delta = { enable = true; };
  };
}
