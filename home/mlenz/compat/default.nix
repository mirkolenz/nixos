{lib, ...}: {
  imports =
    (lib.optional lib.custom.isStable ./stable.nix)
    ++ (lib.optional lib.custom.isUnstable ./unstable.nix);
}
