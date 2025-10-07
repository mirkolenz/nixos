{ prev }:
(prev.samba4.override {
  enableMDNS = true;
}).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      updateScript = null;
    };
  })
