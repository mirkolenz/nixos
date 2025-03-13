{ lib, ... }:
let
  languages = {
    tex.opts = {
      shiftwidth = 2;
      tabstop = 2;
      wrap = true;
    };
  };
in
{
  files = lib.mapAttrs' (name: value: {
    name = "ftplugin/${name}.lua";
    inherit value;
  }) languages;
}
