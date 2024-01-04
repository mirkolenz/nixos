lib: rec {
  mkOptions = let
    isNameValuePair = value:
      builtins.attrNames value
      == ["name" "value"]
      && builtins.isString value.name;

    mkDefaultValue = lib.generators.mkValueStringDefault {};

    mkListOptionValue = values: let
      filteredValues = builtins.filter (v: v != null) values;
      convertedValues = builtins.map mkDefaultValue filteredValues;
    in
      lib.concatStringsSep "," convertedValues;

    concatAttrsOptionValue = attrs: let
      filteredAttrs = lib.filterAttrs (k: v: v != null) attrs;
      mkKeyValue = k: v: "${k}=${mkDefaultValue v}";
      convertedAttrs = lib.mapAttrsToList mkKeyValue filteredAttrs;
    in
      mkListOptionValue convertedAttrs;

    mkNestedAttrsOptionValuePair = {
      name,
      value,
    }: "${name}:${concatAttrsOptionValue value}";

    mkAttrsOptionValuePair = {
      name,
      value,
    }: "${name}=${mkDefaultValue value}";

    mkAttrsOptionValue = attrs:
      if isNameValuePair attrs && attrs.value == null
      then attrs.name
      else if isNameValuePair attrs && builtins.isAttrs attrs.value
      then mkNestedAttrsOptionValuePair attrs
      else if isNameValuePair attrs
      then mkAttrsOptionValuePair attrs
      else concatAttrsOptionValue attrs;

    mkOptionValue = v:
      if builtins.isList v
      then mkListOptionValue v
      else if builtins.isAttrs v
      then mkAttrsOptionValue v
      else mkDefaultValue v;

    mkOptionName = k:
      if builtins.stringLength k == 1
      then "-${k}"
      else "--${k}";

    mkOption = k: v:
      if
        (v == null)
        || (builtins.isList v && builtins.length v == 0)
        || (builtins.isAttrs v && builtins.length (builtins.attrNames v) == 0)
      then []
      else [(mkOptionName k) (mkOptionValue v)];

    mkFlag = k: v: lib.optional v (mkOptionName k);
    mkRepeatedOption = k: v: lib.concatMap (mkOption k) v;

    render = k: v:
      if builtins.isBool v
      then mkFlag k v
      else if builtins.isList v
      then mkRepeatedOption k v
      else mkOption k v;
  in
    options: builtins.concatLists (lib.mapAttrsToList render options);

  mkVolumes = let
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
  in
    values: builtins.map mkVolume values;

  mkCaps = attrs: let
    _attrs =
      {
        NET_RAW = true;
        NET_BIND_SERVICE = true;
      }
      // attrs;
  in
    mkOptions {
      cap-add = builtins.attrNames (lib.filterAttrs (k: v: v) _attrs);
      cap-drop = builtins.attrNames (lib.filterAttrs (k: v: !v) _attrs);
    };

  mkSysctls = attrs:
    mkOptions {
      sysctl = lib.attrsToList (lib.flocken.getLeaves (
        {
          # https://stackoverflow.com/a/66892807
          net.ipv4.ip_unprivileged_port_start = 0;
        }
        // attrs
      ));
    };

  mkEnv = attrs:
    mkOptions {
      env = lib.attrsToList (
        {
          TZ = "Europe/Berlin";
        }
        // attrs
      );
    };

  mkUserns = value:
    mkOptions {
      subuidname = value;
      subgidname = value;
    };

  mkHosts = let
    mkHost = name: value: "${name}:${value}";
  in
    attrs:
      mkOptions {
        add-host = lib.mapAttrsToList mkHost attrs;
      };

  mkImage = image:
    if builtins.isString image
    then image
    else if image.registry == null
    then "${image.name}:${image.tag}"
    else "${image.registry}/${image.name}:${image.tag}";

  mkLabels = attrs: lib.flocken.getLeaves attrs;

  mkLinks = networks: containers: let
    mkLink = container: link: let
      prefix = networks.${link.network}.prefix;
      suffix = containers.${container}.networks.${link.network}.suffix;
      ip = "${prefix}.${suffix}";
    in "${link.name}:${ip}";
  in
    attrs:
      mkOptions {
        add-host = lib.mapAttrsToList mkLink attrs;
      };

  mkNetworks = networks: let
    mkNetwork = name: value:
      lib.nameValuePair name {
        inherit (value) alias mac;
        ip = "${networks.${name}.prefix}.${value.suffix}";
        interface_name = value.interface;
      };
  in
    attrs:
      assert (lib.assertMsg (builtins.length (builtins.attrNames attrs) > 0) "At least one network must be specified.");
        mkOptions {
          network = lib.mapAttrsToList mkNetwork attrs;
        };
}
