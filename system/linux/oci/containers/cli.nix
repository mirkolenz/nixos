lib: let
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

  mkAttrsOptionValue = {_prefix, ...} @ attrs: let
    filteredAttrs = builtins.removeAttrs attrs ["_prefix"];
    concatAttrs = concatAttrsOptionValue filteredAttrs;
  in "${_prefix}:${concatAttrs}";

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
