inputs:
let
  inherit (inputs.nixpkgs) lib;
in
rec {
  flocken = inputs.flocken.lib;
  systemInput =
    {
      name,
      channel,
      os,
    }:
    inputs."${name}-${os}-${channel}" or inputs.${name};
  systemOs = system: lib.last (lib.splitString "-" system);
  systemArch = system: lib.head (lib.splitString "-" system);
  # compare two lists irrespective of order
  setEqual = list1: list2: (lib.naturalSort list1) == (lib.naturalSort list2);
  mkRegistryText =
    os:
    lib.strings.toJSON {
      version = 2;
      flakes =
        lib.mapAttrsToList
          (name: value: {
            exact = true;
            from = {
              type = "indirect";
              id = name;
            };
            to = {
              type = "path";
              path = value.outPath;
            };
          })
          {
            self = inputs.self;
            nixpkgs = inputs.nixpkgs;
            stable = systemInput {
              inherit os;
              channel = "stable";
              name = "nixpkgs";
            };
            unstable = systemInput {
              inherit os;
              channel = "unstable";
              name = "nixpkgs";
            };
            pkgs = systemInput {
              inherit os;
              channel = "unstable";
              name = "nixpkgs";
            };
          };
    };
  mkVimKeymap =
    {
      raw,
      prefix ? "",
      suffix ? "",
      mode ? "n",
    }:
    attrs:
    attrs
    // {
      action =
        if raw then
          { __raw = "function() ${prefix}${attrs.action}${suffix} end"; }
        else
          "<cmd>${prefix}${attrs.action}${suffix}<CR>";
      mode = attrs.mode or mode;
    };
  mkVimKeymaps = opts: values: map (mkVimKeymap opts) values;

  mdFormat = lib.types.submodule (
    { config, ... }:
    {
      options = {
        metadata = lib.mkOption {
          type =
            # https://github.com/NixOS/nixpkgs/blob/130323cfcfdfe3a28da4f9ca4593f053f07c7487/pkgs/pkgs-lib/formats.nix#L125C7-L141C19
            with lib.types;
            let
              valueType =
                nullOr (oneOf [
                  bool
                  int
                  float
                  str
                  path
                  (attrsOf valueType)
                  (listOf valueType)
                ])
                // {
                  description = "JSON value";
                };
            in
            valueType;
          default = { };
          description = "Frontmatter for the markdown file, written as YAML.";
        };
        body = lib.mkOption {
          type = lib.types.lines;
          description = "Markdown content for the file.";
        };
        text = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
        };
      };
      config = {
        text =
          if config.metadata == { } then
            config.body
          else
            ''
              ---
              ${lib.strings.toJSON config.metadata}
              ---

              ${config.body}
            '';
      };
    }
  );

  importOverlays =
    dir: final: prev:
    let
      filterPath =
        name: type:
        !lib.hasPrefix "_" name && type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
      dirContents = builtins.readDir dir;
      filteredContents = lib.filterAttrs filterPath dirContents;
      filteredPaths = builtins.attrNames filteredContents;
    in
    lib.listToAttrs (
      map (name: {
        name = lib.removeSuffix ".nix" name;
        value = import (dir + "/${name}") final prev;
      }) filteredPaths
    );
}
