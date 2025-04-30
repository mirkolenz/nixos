{ nixpkgs, fetchurl }:
nixpkgs.mas.overrideAttrs rec {
  version = "2.2.2";
  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
    hash = "sha256-v+tiD5ZMVFzeShyuOt8Ss3yw6p8VjopHaMimOQznL6o=";
  };
}
