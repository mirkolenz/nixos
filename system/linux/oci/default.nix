{
  lib,
  config,
  mylib,
  ...
}: let
  cfg = config.custom.oci;
in {
  imports = mylib.importFolder ./.;
  options.custom.oci = with lib; {
    enable = mkEnableOption "Enable OCI containers";

    subidname = mkOption {
      type = with types; str;
    };
  };

  config = lib.mkIf (cfg.enable) {
    virtualisation.oci-containers.backend = "podman";
  };
}
