{...}: {
  nix.linux-builder = {
    enable = true;
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
