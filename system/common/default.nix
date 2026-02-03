{ lib', pkgs, ... }:
{
  imports = lib'.flocken.getModules ./.;

  time.timeZone = "Europe/Berlin";

  environment = {
    variables = {
      PAGER = "less";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
    defaultPackages = [ ];
    systemPackages = with pkgs; [
      perl
      python3
      rsync
    ];
  };
}
