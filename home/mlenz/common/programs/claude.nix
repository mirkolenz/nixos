{ config, ... }:
{
  programs.claude = {
    enable = config.custom.profile.isWorkstation;
    settings = {
      model = "opus";
    };
  };
}
