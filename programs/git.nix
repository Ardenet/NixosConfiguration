{lib, ...}: {
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "ardenet";
        email = "69284622+ardenet@users.noreply.github.com";
        signingkey = "~/.ssh/sign_commit.pub";
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
      pull = {
        rebase = false;
      };
      gpg = {
        format = "ssh";
      };
      commit = {
        gpgsign = true;
      };
      tag = {
        gpgsign = true;
      };
      "gpg \"ssh\"" = {
        allowedSignersFile = "~/.config/git/allowed_signers";
      };
    };
  };
}
