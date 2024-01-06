lib: rec {
  stableVersion = "23.11";
  unstableVersion = "24.05";
  isStable = checkedLib: lib.versionOlder checkedLib.trivial.release unstableVersion;
  isUnstable = checkedLib: lib.versionAtLeast checkedLib.trivial.release unstableVersion;
  getOs = system: lib.last (lib.splitString "-" system);
}
