{...}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./shell.nix
    ./secrets.nix
    ../../home
  ];

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
