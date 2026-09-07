{
  configurations.nixos.macbook-161.module =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      # https://github.com/t2linux/linux-t2-patches
      # nix run .#t2-updater -- --branch main ./modules/hosts/macbook-161/kernel.json
      upstreamKernel =
        pkgs.callPackage "${inputs.nixos-hardware}/apple/t2/pkgs/linux-t2/generic.nix" { }
          {
            kernel = pkgs.linux_7_2;
            patchesFile = ./kernel.json;
          };
      kernel = upstreamKernel.override {
        # https://github.com/deqrocks/t2bce
        structuredExtraConfig = with lib.kernel; {
          APFS_FS = module;
          APPLE_GMUX = module;
          BRCMFMAC = module;
          BT_BCM = module;
          BT_HCIBCM4377 = module;
          BT_HCIUART = module;
          BT_HCIUART_BCM = yes;
          DRM_APPLETBDRM = module;
          HID_APPLE = module;
          HID_APPLETB_BL = module;
          HID_APPLETB_KBD = module;
          HID_MAGICMOUSE = module;
          HID_SENSOR_ALS = module;
          SENSORS_APPLESMC = module;
          SND_PCM = module;
          STAGING = yes;
          T2BCE_AUDIO = module;
          T2BCE_CORE = module;
          T2BCE_DMA = module;
          T2BCE_VHCI = module;
        };
      };
    in
    {
      boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor kernel);
      boot.initrd.kernelModules = lib.mkForce [
        "t2bce_dma"
        "t2bce_core"
        "t2bce_vhci"
      ];
    };
}
