{
  lib,
  lib',
  ...
}: {
  imports =
    (lib.optional (lib'.self.isStable lib) ./stable.nix)
    ++ (lib.optional (lib'.self.isUnstable lib) ./unstable.nix);
}
