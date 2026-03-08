{
  pkgs,
  ...
}:
{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
  };
}
