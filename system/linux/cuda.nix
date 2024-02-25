{ config, lib, ... }:
let
  cfg = config.custom.cuda;
in
{
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
    xserverDriver = lib.mkOption {
      type = lib.types.str;
      default = "nvidia";
      description = "Name of the xserver driver to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    # nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ cfg.xserverDriver ];
    virtualisation.containers.cdi.dynamic.nvidia.enable = true;
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
    nix.settings = {
      substituters = [ "https://cuda-maintainers.cachix.org" ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dp3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };
}
