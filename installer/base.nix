{ extras, lib, ... }:
let
  inherit (extras.inputs) mlenz-ssh-keys;
in
{
  system = {
    inherit (extras) stateVersion;
  };
  users.users.root.openssh.authorizedKeys.keyFiles = [ (builtins.toString mlenz-ssh-keys) ];
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  services.openssh.enable = true;

  programs = {
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
