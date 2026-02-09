final: prev:
let
  pkgs = prev;
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
