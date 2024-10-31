lib: rec {
  systemInput =
    {
      inputs,
      name,
      channel,
      os,
    }:
    inputs."${name}-${os}-${channel}" or inputs."${name}-${channel}" or inputs.${name};
  systemOs = system: lib.last (lib.splitString "-" system);
  systemArch = system: builtins.head (lib.splitString "-" system);
  # compare two lists irrespective of order
  setEqual = list1: list2: (lib.naturalSort list1) == (lib.naturalSort list2);
  filterPackagePlatforms =
    {
      system,
      packages,
      defaultPlatforms ? [ system ],
    }:
    lib.filterAttrs (_: v: lib.elem system (v.meta.platforms or defaultPlatforms)) packages;
  mkRegistry =
    {
      channel,
      inputs,
      os,
    }:
    {
      stable.flake = systemInput {
        inherit inputs os;
        channel = "stable";
        name = "nixpkgs";
      };
      unstable.flake = systemInput {
        inherit inputs os;
        channel = "unstable";
        name = "nixpkgs";
      };
      pkgs.flake = systemInput {
        inherit inputs os channel;
        name = "nixpkgs";
      };
      nixpkgs.flake = systemInput {
        inherit inputs os channel;
        name = "nixpkgs";
      };
      self.flake = inputs.self;
    };
}
