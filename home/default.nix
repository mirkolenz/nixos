{ config, extras, pkgs, lib, ... }:
let
  inherit (pkgs) stdenv;
  defaults = { ... }: {
    _module.args = { inherit extras; };
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mlenz.imports = [
      defaults
      ./mlenz/common.nix
    ] ++ (lib.optionals stdenv.isDarwin [
      ./mlenz/darwin.nix
    ]) ++ (lib.optionals stdenv.isLinux [
      ./mlenz/linux.nix
    ]) ++ (lib.optionals (stdenv.isLinux && config.services.xserver.enable) [
      ./mlenz/xserver.nix
    ]);
  };
}
