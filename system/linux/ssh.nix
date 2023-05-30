{flakeInputs, ...}: let
  inherit (flakeInputs) mlenz-ssh-keys;
in {
  services.openssh = {
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };
  # https://discourse.nixos.org/t/fetching-ssh-public-keys/12076
  users.users.mlenz = {
    openssh.authorizedKeys.keyFiles = [(builtins.toString mlenz-ssh-keys)];
  };
}
