{
  lib,
  pkgs,
  ...
}: let
  json = pkgs.formats.json {};

  generate = name: network: let
    dns_enabled = network.driver == "bridge";
    networkConfig =
      {
        inherit name dns_enabled;
        inherit (network) driver id subnets internal;
        network_interface = network.interface;
        created = "2020-01-01T06:00:00.000000000+01:00";
        ipam_options.driver = "host-local";
        ipv6_enabled = network.ipv6;
      }
      (lib.optionalAttrs dns_enabled {
        network_dns_servers = network.dns;
      });
  in
    lib.mkIf network.enable (
      json.generate "${name}.json" networkConfig
    );
in {
  inherit generate;
  submodule = {
    options = with lib; {
      enable = mkOption {
        type = with types; bool;
        default = true;
      };
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
      dns = mkOption {
        type = with types; listOf str;
        default = [];
      };
      internal = mkEnableOption "Restrict access to internal";
      ipv6 = mkEnableOption "IPv6 support";
    };
  };
}
