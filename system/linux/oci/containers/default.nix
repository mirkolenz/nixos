{
  config,
  lib,
  ...
}: let
  mkCliOptions = import ./cli.nix lib;
  cfg = config.custom.oci;
  containersCfg = cfg.containers;
  networksCfg = cfg.networks;

  mkNetwork = name: value:
    lib.nameValuePair name {
      inherit (value) alias mac;
      ip = "${networksCfg.${name}.prefix}.${value.suffix}";
      interface_name = value.interface;
    };
  mkNetworks = attrs:
    assert (lib.assertMsg (builtins.length (builtins.attrNames attrs) > 0) "At least one network must be specified.");
      mkCliOptions {
        network = lib.mapAttrsToList mkNetwork attrs;
      };

  mkHost = name: value: "${name}:${value}";
  mkHosts = attrs:
    mkCliOptions {
      add-host = lib.mapAttrsToList mkHost attrs;
    };

  mkLink = container: link: let
    prefix = networksCfg.${link.network}.prefix;
    suffix = containersCfg.${container}.networks.${link.network}.suffix;
    ip = "${prefix}.${suffix}";
  in "${link.name}:${ip}";
  mkLinks = attrs:
    mkCliOptions {
      add-host = lib.mapAttrsToList mkLink attrs;
    };

  mkAttrVolume = {
    source,
    target,
    mode ? null,
  }:
    if mode == null
    then "${source}:${target}"
    else "${source}:${target}:${mode}";
  mkListVolume = values: lib.concatStringsSep ":" values;
  mkVolume = value:
    if builtins.isAttrs value
    then mkAttrVolume value
    else if builtins.isList value
    then mkListVolume value
    else value;
  mkVolumes = values: builtins.map mkVolume values;

  mkCaps = attrs:
    mkCliOptions {
      cap-add = builtins.attrNames (lib.filterAttrs (k: v: v) attrs);
      cap-drop = builtins.attrNames (lib.filterAttrs (k: v: !v) attrs);
    };

  mkImage = image:
    if builtins.isAttrs image
    then "${image.registry}/${image.name}:${image.tag}"
    else image;

  defaultCaps = {
    NET_RAW = true;
    NET_BIND_SERVICE = true;
  };
  defaultEnv = {TZ = "Europe/Berlin";};

  mkContainer = name: container:
    lib.mkIf container.enable {
      inherit
        (container)
        imageFile
        cmd
        environmentFiles
        ports
        user
        workdir
        hostname
        autoStart
        ;

      image = mkImage container.image;
      environment = defaultEnv // container.environment;
      volumes = mkVolumes container.volumes;
      dependsOn =
        container.dependsOn
        ++ (builtins.attrNames
          (
            lib.filterAttrs
            (name: value: value.required)
            container.links
          ));
      labels =
        container.labels
        // (
          lib.optionalAttrs
          (container.update != null)
          {"io.containers.autoupdate" = container.update;}
        );
      extraOptions =
        (mkCliOptions {
          pull = container.pull;
          subuidname = container.subidname;
          subgidname = container.subidname;
        })
        ++ (mkNetworks container.networks)
        ++ (mkHosts container.hosts)
        ++ (mkLinks container.links)
        ++ (mkCaps (defaultCaps // container.caps))
        ++ (mkCliOptions container.extraOptions)
        ++ container.extraArgs;
    };
in {
  options.custom.oci.containers = with lib;
    mkOption {
      default = {};
      type = with types; attrsOf (submodule (import ./submodule.nix));
    };
  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers =
      lib.mapAttrs (
        name: value: mkContainer name value
      )
      containersCfg;
    systemd.services =
      lib.mapAttrs' (name: value: {
        name = "podman-${name}";
        value = value.systemd;
      })
      containersCfg;
  };
}
