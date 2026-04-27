{ lib, prev }:
lib.addMetaAttrs
  {
    hydraPlatforms = lib.platforms.linux;
  }
  (
    prev.samba4.override {
      enableMDNS = true;
    }
  )
