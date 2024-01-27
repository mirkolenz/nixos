lib: rec {
  stableVersion = "23.11";
  unstableVersion = "24.05";
  isStable = release: lib.versionOlder release unstableVersion;
  isUnstable = release: lib.versionAtLeast release unstableVersion;
  channel = release:
    if (isStable release)
    then "stable"
    else "unstable";
  systemInput = {
    inputs,
    name,
    channel,
    os,
  }:
    inputs."${name}-${os}-${channel}" or inputs.${name};
  systemOs = system: lib.last (lib.splitString "-" system);
  systemArch = system: builtins.head (lib.splitString "-" system);
}
