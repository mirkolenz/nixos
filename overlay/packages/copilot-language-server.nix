# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.352.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-Fx0pkQSlmerBW67zZ0IqYI15T5QHTcYHPMNm0LoOyq8=";
    stripRoot = false;
  };
})
