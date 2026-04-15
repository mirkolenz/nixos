final: prev:
let
  pkgs = final;
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
