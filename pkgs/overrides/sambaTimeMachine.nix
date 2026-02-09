final: prev:
let
  pkgs = prev;
  inherit (pkgs) lib;
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
