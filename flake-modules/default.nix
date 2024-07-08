{
  lib',
  inputs,
  specialModuleArgs,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;
  perSystem =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = import ../nixpkgs-config.nix;
        overlays = import ../overlays specialModuleArgs;
      };
      formatter = pkgs.nixfmt;
      packages =
        {
          inherit (pkgs) bibtexbrowser2cff; # bibtex2cff
        }
        // (lib.optionalAttrs pkgs.stdenv.isDarwin {
          inherit (pkgs) neovide-bin restic-browser-bin vimr-bin;
        });
    };
  flake = {
    lib = lib'.self;
  };
}
