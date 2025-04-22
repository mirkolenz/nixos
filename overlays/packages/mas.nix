{ nixpkgs, fetchurl }:
nixpkgs.mas.overrideAttrs (oldAttrs: rec {
  version = "2.1.0";
  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
    hash = "sha256-pT8W/ZdNP7Fv5nyTX9vKbTa2jIk3THN1HVCmuEIibfc=";
  };
})
