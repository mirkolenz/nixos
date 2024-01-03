lib: rec {
  stableVersion = "23.11";
  unstableVersion = "24.05";
  isStable = lib.versionOlder lib.trivial.release unstableVersion;
  isUnstable = lib.versionAtLeast lib.trivial.release unstableVersion;
}
