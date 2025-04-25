{ nixpkgs, fetchurl }:
nixpkgs.mas.overrideAttrs (oldAttrs: rec {
  version = "2.2.1";
  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
    hash = "sha256-Nk4rJP9vEZgQtveRBzN2eYNnVMCppVBuiCpXZ/PfNE8=";
  };
})
