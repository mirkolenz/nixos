lib: rec {
  stableVersion = "23.11";
  unstableVersion = "24.05";
  isStable = checkedLib: lib.versionOlder checkedLib.trivial.release unstableVersion;
  isUnstable = checkedLib: lib.versionAtLeast checkedLib.trivial.release unstableVersion;
  systemOs = system: lib.last (lib.splitString "-" system);
  systemArch = system: builtins.head (lib.splitString "-" system);
}
