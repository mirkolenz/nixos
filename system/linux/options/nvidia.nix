{ config, lib, ... }:
let
  cfg = config.custom.nvidia;
in
{
  options.custom.nvidia = {
    enable = lib.mkEnableOption "NVIDIA";
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
    services.xserver.videoDrivers = [ cfg.xserverDriver ];
    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
      nvidia.package = config.boot.kernelPackages.nvidiaPackages.${cfg.driver};
    };
  };
}
