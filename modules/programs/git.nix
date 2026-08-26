{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "wk";
        email = "58632380+wkai343@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };
}
