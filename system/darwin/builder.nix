{...}: {
  nix.linux-builder = {
    enable = false;
    modules = [
      # {
      #   virtualisation.darwin-builder = {
      #     diskSize = 5120;
      #     memorySize = 1024;
      #   };
      # }
    ];
  };
}
