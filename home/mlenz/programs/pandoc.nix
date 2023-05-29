{
  extras,
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.pandoc = {
    enable = pkgs.stdenv.isDarwin || osConfig.services.xserver.enable;
  };
}
