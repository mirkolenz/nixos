# https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
{
  inputs,
  pkgs,
}: {
  stable.flake =
    if pkgs.stdenv.isDarwin
    then inputs.nixpkgs-darwin-stable
    else inputs.nixpkgs-linux-stable;
  unstable.flake =
    if pkgs.stdenv.isDarwin
    then inputs.nixpkgs-darwin-unstable
    else inputs.nixpkgs-linux-unstable;
  pkgs.flake =
    if pkgs.stdenv.isDarwin
    then inputs.nixpkgs-darwin-unstable
    else inputs.nixpkgs-linux-unstable;
  nixpkgs.flake =
    if pkgs.stdenv.isDarwin
    then inputs.nixpkgs-darwin-unstable
    else inputs.nixpkgs-linux-unstable;
  self.flake = inputs.self;
}
