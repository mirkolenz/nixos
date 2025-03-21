{ lib, ... }:
{
  options.keymaps = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options.options = {
          replace_keycodes = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
            description = "Replace keycodes with their corresponding keys";
          };
        };
      }
    );
  };
}
