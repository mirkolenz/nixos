{
  pkgs,
  lib,
  ...
}: let
  username = "mlenz";
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";
  userid = 1000;
in {
  users = {
    users.root = lib.mkIf pkgs.stdenv.isLinux {
      # Disable root login
      # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235/2
      hashedPassword = "!";
    };
    users.${username} = lib.mkMerge [
      {
        description = "Mirko Lenz";
        home = homeDirectory;
        uid = userid;
        shell = pkgs.fish;
      }
      (lib.mkIf pkgs.stdenv.isLinux {
        group = username;
        extraGroups = [username "users" "networkmanager" "wheel"];
        isNormalUser = true;
        initialHashedPassword = "$y$j9T$PNrr2mfD3mtxoSfR26fYh/$qNvFLgYOJFAms5MwZ42vM0F0aUP.ceHpD0j4LAr7IP5";
      })
      (lib.mkIf pkgs.stdenv.isDarwin {
        gid = userid;
      })
    ];
    groups.${username} = {
      gid = userid;
    };
  };
}
