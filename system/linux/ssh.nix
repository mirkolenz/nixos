{inputs, ...}: {
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "no";
    X11Forwarding = false;
  };
  # https://discourse.nixos.org/t/fetching-ssh-public-keys/12076
  users.users.mlenz = {
    openssh.authorizedKeys.keyFiles = [(builtins.toString inputs.mlenz-ssh-keys)];
  };
}
