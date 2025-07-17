{ userSettings, ... }:

{
  programs.git = {
    enable = true;
    userName = userSettings.username;
    userEmail = userSettings.username + "@users.noreply.github.com";
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
    };
    delta = { enable = true; };
  };
}
