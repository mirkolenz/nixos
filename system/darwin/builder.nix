{
  config,
  lib,
  ...
}: let
  cfg = config.custom.builder;
in {
  options.custom.builder = {
    enable = lib.mkOption {
      default = false;
      example = false;
      description = "Enable the Darwin linux builder";
      type = lib.types.bool;
    };
    uncachedHardware = lib.mkEnableOption "Use better hardware for vm that is not cached by hydra";
  };
  config = lib.mkIf cfg.enable {
    nix.linux-builder = {
      enable = true;
      modules = lib.mkIf cfg.uncachedHardware [
        {
          # https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/nixos/modules/profiles/macos-builder.nix
          virtualisation.darwin-builder = {
            diskSize = 20 * 1024;
            memorySize = 6 * 1024;
          };
        }
      ];
    };
  };
}
