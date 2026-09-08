{
  flake.modules.nixos.apple-t2 =
    { pkgs, ... }:
    {
      # nix build .#packages.x86_64-linux.linux-t2
      boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux-t2;
      # Needed for the internal keyboard and trackpad
      boot.initrd.kernelModules = [
        "t2bce_dma"
        "t2bce_core"
        "t2bce_vhci"
      ];
    };
}
