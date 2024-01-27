{
  lib,
  lib',
  ...
}: {
  imports =
    (lib.optional (lib'.self.isStable lib.trivial.release) ./stable.nix)
    ++ (lib.optional (lib'.self.isUnstable lib.trivial.release) ./unstable.nix);
}
