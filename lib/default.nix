lib: rec {
  stableVersion = "23.11";
  unstableVersion = "24.05";
  isStable = lib': lib.versionOlder lib'.trivial.release unstableVersion;
  isUnstable = lib': lib.versionAtLeast lib'.trivial.release unstableVersion;
  channel = lib':
    if (isStable lib')
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
