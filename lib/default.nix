lib: {
  systemInput =
    {
      inputs,
      name,
      channel,
      os,
    }:
    inputs."${name}-${os}-${channel}" or inputs.${name};
  systemOs = system: lib.last (lib.splitString "-" system);
  systemArch = system: builtins.head (lib.splitString "-" system);
}
