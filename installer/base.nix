{
  inputs,
  lib,
  stateVersion,
  ...
}: {
  system = {
    inherit stateVersion;
  };
  users.users.root.openssh.authorizedKeys.keyFiles = [(builtins.toString inputs.mlenz-ssh-keys)];
  systemd.services.sshd.wantedBy = lib.mkForce ["multi-user.target"];
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
