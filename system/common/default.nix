{...}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./secrets.nix
    ./shell.nix
    ./ssh.nix
  ];

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
