{ extras, lib, ... }:
let
  inherit (extras.inputs) mlenz-ssh-keys;
in
{
  system = {
    inherit (extras) stateVersion;
  };
  users.users.root.openssh.authorizedKeys.keyFiles = [ mlenz-ssh-keys.outPath ];
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  services.openssh.enable = true;
}
