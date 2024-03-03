{
  lib,
  lib',
  config,
  ...
}:
let
  cfg = config.custom.oci;
in
{
  imports = lib'.flocken.getModules ./.;
  options.custom.oci = with lib; {
    enable = mkEnableOption "Enable OCI containers";

    userns = mkOption { type = with types; str; };
  };

  config = lib.mkIf (cfg.enable) { virtualisation.oci-containers.backend = "podman"; };
}
