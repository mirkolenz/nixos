{lib', ...}: {
  imports = lib'.flocken.getModules ./.;
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
