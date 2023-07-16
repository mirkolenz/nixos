{...}: {
  nix.linux-builder = {
    enable = false;
    modules = [
      # swraid accesses system.stateVersion which throws an error in the builder
      # https://github.com/NixOS/nixpkgs/pull/183314/files
      # {
      #   boot.swraid.enable = false;
      # }
    ];
  };
}
