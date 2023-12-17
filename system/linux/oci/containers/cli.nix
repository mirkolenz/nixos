lib: let
  isNameValuePair = value:
    builtins.isAttrs value
    && (builtins.attrNames value) == ["name" "value"]
    && builtins.isString value.name
    && builtins.isAttrs value.value;

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

  mkAttrsOptionValuePair = {
    name,
    value,
  }: "${name}:${concatAttrsOptionValue value}";

  mkAttrsOptionValue = attrs:
    if isNameValuePair attrs
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
    if v == null
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
  options: builtins.concatLists (lib.mapAttrsToList render options)
