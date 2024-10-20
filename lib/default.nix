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
  filterAttrsByPlatform =
    system: platforms: pkgs:
    lib.optionalAttrs (lib.elem system platforms) (
      lib.filterAttrs (_: pkg: setEqual (pkg.meta.platforms or [ ]) platforms) pkgs
    );
}
