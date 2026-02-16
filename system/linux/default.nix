{
  lib',
  pkgs,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    _1password.enable = true;
    nix-ld.enable = true;
  };

  environment.variables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    pciutils
    strace
    perl
    python3
    rsync
  ];
}
