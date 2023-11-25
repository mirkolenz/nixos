# https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
{
  inputs,
  pkgs,
}: {
  stable.flake =
    if pkgs.stdenv.isDarwin
    then builtins.toString inputs.nixpkgs-darwin-stable
    else builtins.toString inputs.nixpkgs-linux-stable;
  unstable.flake =
    if pkgs.stdenv.isDarwin
    then builtins.toString inputs.nixpkgs-darwin-unstable
    else builtins.toString inputs.nixpkgs-linux-unstable;
  pkgs.flake =
    if pkgs.stdenv.isDarwin
    then builtins.toString inputs.nixpkgs-darwin-unstable
    else builtins.toString inputs.nixpkgs-linux-unstable;
  self.flake = builtins.toString inputs.self;
}
