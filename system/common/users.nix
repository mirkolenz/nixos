{
  pkgs,
  lib,
  user,
  ...
}:
let
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.login}" else "/home/${user.login}";
in
{
  users = {
    users.root = lib.mkIf pkgs.stdenv.isLinux {
      # Disable root login
      # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235/2
      initialHashedPassword = lib.mkDefault "!";
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
        extraGroups = [
          "users"
          "wheel"
          "video"
          "audio"
        ];
        isNormalUser = true;
        initialHashedPassword = "$y$j9T$PNrr2mfD3mtxoSfR26fYh/$qNvFLgYOJFAms5MwZ42vM0F0aUP.ceHpD0j4LAr7IP5";
        openssh.authorizedKeys.keys = user.sshKeys;
        subUidRanges = [
          {
            count = 65536;
            startUid = 100000;
          }
        ];
        subGidRanges = [
          {
            count = 65536;
            startGid = 100000;
          }
        ];
      })
      (lib.mkIf pkgs.stdenv.isDarwin { gid = user.id; })
    ];
    groups.${user.login} = {
      gid = user.id;
    };
  };
}
