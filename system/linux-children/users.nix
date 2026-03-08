{
  user,
  lib,
  ...
}:
{
  users.users = {
    mirko = {
      description = "Mirko Lenz";
      uid = lib.mkDefault 1000;
      isNormalUser = true;
      openssh.authorizedKeys.keys = user.sshKeys;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
    mila = {
      description = "Mila Lenz";
      uid = lib.mkDefault 1001;
      isNormalUser = true;
      password = "";
    };
    levi = {
      description = "Levi Lenz";
      uid = lib.mkDefault 1002;
      isNormalUser = true;
      password = "";
    };
  };
}
