final: prev:
let
  # todo: https://github.com/nixos/nixpkgs/issues/502964
  pkgs = final.stable;
  inherit (prev) lib;
in
lib.addMetaAttrs
  {
    hydraPlatforms = lib.platforms.linux;
  }
  (
    pkgs.samba4.override {
      enableMDNS = true;
    }
  )
