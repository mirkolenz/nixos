{...}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./shell.nix
    ./secrets.nix
    ../../home
    ../cachix
  ];

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
