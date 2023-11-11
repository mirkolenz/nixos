# https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
{
  inputs,
  stdenv,
}: rec {
  stable.flake =
    if stdenv.isDarwin
    then inputs.nixpkgs-darwin-stable
    else inputs.nixpkgs-linux-stable;
  unstable.flake =
    if stdenv.isDarwin
    then inputs.nixpkgs-darwin-unstable
    else inputs.nixpkgs-linux-unstable;
  pkgs.flake = unstable.flake;
  self.flake = inputs.self;
}
