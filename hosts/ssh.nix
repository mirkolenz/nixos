{ extras, lib, ... }:
let
  inherit (extras.inputs) mlenz-ssh-keys;
in
{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };
  # https://discourse.nixos.org/t/fetching-ssh-public-keys/12076
  users.users.mlenz = {
    openssh.authorizedKeys.keyFiles = [ mlenz-ssh-keys.outPath ];
  };
}
