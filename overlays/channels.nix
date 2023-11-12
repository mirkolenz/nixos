inputs: (final: prev: {
  stable =
    if final.stdenv.isDarwin
    then
      import inputs.nixpkgs-darwin-stable {
        system = final.pkgs.system;
        config = import ../nixpkgs-config.nix;
      }
    else
      import inputs.nixpkgs-linux-stable {
        system = final.pkgs.system;
        config = import ../nixpkgs-config.nix;
      };
  unstable =
    if final.stdenv.isDarwin
    then
      import inputs.nixpkgs-darwin-unstable {
        system = final.pkgs.system;
        config = import ../nixpkgs-config.nix;
      }
    else
      import inputs.nixpkgs-linux-unstable {
        system = final.pkgs.system;
        config = import ../nixpkgs-config.nix;
      };
})
