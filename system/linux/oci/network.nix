{
  cfg,
  lib,
  pkgs,
}: let
  json = pkgs.formats.json {};

  generate = name: network:
    json.generate "${name}.json" {
      inherit name;
      inherit (network) driver id subnets internal;
      network_interface = network.interface;
      created = "2020-01-01T06:00:00.000000000+01:00";
      ipv6_enabled = network.ipv6;
      dns_enabled = network.driver == "bridge";
      ipam_options.driver = "host-local";
    };
in {
  inherit generate;
  submodule = {
    options = with lib; {
      driver = mkOption {
        type = types.enum ["bridge" "macvlan"];
        default = "bridge";
      };
      prefix = mkOption {
        type = with types; str;
      };
      id = mkOption {
        type = with types; str;
      };
      interface = mkOption {
        type = with types; str;
      };
      subnets = mkOption {
        type = with types; listOf attrs;
        default = [];
      };
      internal = mkEnableOption "Restrict access to internal";
      ipv6 = mkEnableOption "IPv6 support";
    };
  };
}
