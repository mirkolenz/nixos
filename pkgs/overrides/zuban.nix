final: prev:
prev.zuban.overrideAttrs (
  finalAttrs: oldAttrs: {
    version = "0.1.1";
    src = oldAttrs.src.override {
      hash = "sha256-3Rboytxxsn6naAMbZDwxqefBFqStMWYTTOOJ/SVbhRI=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      hash = "sha256-Etjo2/2HKe0fOZKVrAaIZCWiuCp3TOmPGnbxBMfYCHA=";
    };
  }
)
