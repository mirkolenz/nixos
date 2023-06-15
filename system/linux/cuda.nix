{
  config,
  lib,
  ...
}: let
  cfg = config.custom.cuda;
in {
  options.custom.cuda = {
    enable = lib.mkEnableOption "CUDA";
    driver = lib.mkOption {
      type = lib.types.str;
      default = "stable";
      description = ''
        Version of the driver to use.
        List of options:
        https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # nixpkgs.config.cudaSupport = true;
    virtualisation = {
      docker.enableNvidia = true;
      podman.enableNvidia = true;
    };
    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.driver};
        modesetting.enable = true;
      };
    };
  };
}
