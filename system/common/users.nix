{ pkgs, lib, extras, config, ... }:
let
  inherit (extras) pkgsUnstable;
in
{
  users = {
    users.root = lib.mkIf pkgs.stdenv.isLinux {
      # Disable root login
      # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235/2
      hashedPassword = "!";
    };
    users.mlenz = lib.mkMerge [
      {
        description = "Mirko Lenz";
        uid = 1000;
        shell = pkgs.fish;
        packages = with pkgsUnstable; [
          nixpkgs-fmt
          nil
        ];
      }
      (lib.mkIf pkgs.stdenv.isLinux {
        group = "mlenz";
        extraGroups = [ "mlenz" "users" "networkmanager" "wheel" ];
        isNormalUser = true;
        initialHashedPassword = "$y$j9T$PNrr2mfD3mtxoSfR26fYh/$qNvFLgYOJFAms5MwZ42vM0F0aUP.ceHpD0j4LAr7IP5";
      })
      (lib.mkIf pkgs.stdenv.isDarwin {
        gid = 1000;
      })
    ];
    groups.mlenz = {
      gid = 1000;
    };
  };
}
