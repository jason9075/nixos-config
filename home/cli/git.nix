{ userSettings, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userSettings.username;
        email = userSettings.email;
      };
      core.editor = "nvim";
      init.defaultBranch = "main";
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
