{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.oci;
  json = pkgs.formats.json {};

  mkNetwork = name: network: let
    networkConfig =
      {
        inherit name;
        inherit (network) driver id subnets internal;
        network_interface = network.interface;
        created = "2020-01-01T06:00:00.000000000+01:00";
        ipam_options.driver = "host-local";
        ipv6_enabled = network.ipv6;
        # Using aardvark dns currently does not work, hostnames are not resolved
        # https://github.com/containers/podman/pull/17578
        dns_enabled = false;
      }
      // (lib.optionalAttrs (network.driver == "bridge") {
        options = {
          metric = builtins.toString network.metric;
          no_default_route =
            if network.defaultRoute
            then "false"
            else "true";
        };
      });
  in
    lib.mkIf network.enable (
      json.generate "${name}.json" networkConfig
    );
in {
  options.custom.oci.networks = with lib;
    mkOption {
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkOption {
            type = with types; bool;
            default = true;
          };
          metric = mkOption {
            type = with types; int;
          };
          defaultRoute = mkOption {
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
            type = with types; listOf (attrsOf anything);
            default = [];
          };
          internal = mkEnableOption "Restrict access to internal";
          ipv6 = mkEnableOption "IPv6 support";
        };
      });
    };
  config = lib.mkIf cfg.enable {
    environment.etc =
      lib.mapAttrs' (name: value: {
        name = "containers/networks/${name}.json";
        value = {
          source = mkNetwork name value;
        };
      })
      cfg.networks;
  };
}
