{ pkgs, lib, extras, ... }:
let
  inherit (pkgs) stdenv;
  defaults = { ... }: {
    _module.args = { inherit extras; };
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # users.mlenz = import ./home/mlenz.nix;
    users.mlenz = {
      imports = [
        defaults
        ./home/mlenz.nix
      ];
    };
  };
  users = {
    users.mlenz = lib.mkMerge [
      {
        description = "Mirko Lenz";
        uid = 1000;
        shell = pkgs.fish;
        packages = with pkgs; [
          nixpkgs-fmt
          nil
          rnix-lsp
        ];
      }
      (lib.mkIf stdenv.isLinux {
        group = "mlenz";
        extraGroups = [ "mlenz" "users" "networkmanager" "wheel" "docker" ];
        isNormalUser = true;
      })
      (lib.mkIf stdenv.isDarwin {
        gid = 1000;
      })
    ];
    groups.mlenz = {
      description = "Mirko Lenz";
      gid = 1000;
    };
  };
}
