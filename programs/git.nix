{lib, ...}: {
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Ardenet";
        email = "69284622+Ardenet@users.noreply.github.com";
      };
      color = {
        interactive = true;
        ui = "auto";
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      alias = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen($cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
      };
    };
  };
}
