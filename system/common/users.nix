{
  pkgs,
  lib,
  user,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${user.login}"
    else "/home/${user.login}";
in {
  users = {
    users.root = lib.mkIf pkgs.stdenv.isLinux {
      # Disable root login
      # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235/2
      hashedPassword = "!";
    };
    users.${user.login} = lib.mkMerge [
      {
        description = user.name;
        home = homeDirectory;
        uid = user.id;
        shell = pkgs.fish;
      }
      (lib.mkIf pkgs.stdenv.isLinux {
        group = user.login;
        # https://wiki.debian.org/SystemGroups#Other_System_Groups
        extraGroups = ["users" "wheel" "networkmanager" "video" "audio"];
        isNormalUser = true;
        initialHashedPassword = "$y$j9T$PNrr2mfD3mtxoSfR26fYh/$qNvFLgYOJFAms5MwZ42vM0F0aUP.ceHpD0j4LAr7IP5";
        openssh.authorizedKeys.keys = user.sshKeys;
        subUidRanges = [
          {
            count = 1;
            startUid = 1000;
          }
          {
            count = 65536;
            startUid = 100001;
          }
        ];
        subGidRanges = [
          {
            count = 1;
            startGid = 1000;
          }
          {
            count = 65536;
            startGid = 100001;
          }
        ];
      })
      (lib.mkIf pkgs.stdenv.isDarwin {
        gid = user.id;
      })
    ];
    groups.${user.login} = {
      gid = user.id;
    };
  };
}
