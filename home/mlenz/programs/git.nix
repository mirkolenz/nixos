{ extras, lib, ... }:
let
  inherit (extras.inputs) gitignore;
in
{
  programs.git = {
    enable = true;
    userName = "Mirko Lenz";
    userEmail = "mirko@mirkolenz.com";
    lfs = {
      enable = true;
    };
    ignores = lib.splitString "\n" (builtins.readFile gitignore.outPath);
    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "nvim";
        eol = "lf";
      };
      pull = {
        rebase = "true";
      };
      rebase = {
        autoStash = "true";
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        followTags = "true";
        autoSetupRemote = "true";
      };
    };
  };
}
