{...}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./shell.nix
    ./secrets.nix
  ];

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
