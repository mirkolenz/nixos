final: prev:
prev.lib.addMetaAttrs
  {
    hydraPlatforms = prev.lib.platforms.linux;
  }
  (
    prev.samba4.override {
      enableMDNS = true;
    }
  )
