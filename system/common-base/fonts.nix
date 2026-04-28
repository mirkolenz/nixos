{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.custom.features.withDisplay {
  environment.systemPackages =
    with pkgs;
    [
      font-awesome
      lucide
      material-design-icons
      nerd-fonts.symbols-only
    ]
    ++ (lib.optionals stdenv.hostPlatform.isLinux [
      inter
      jetbrains-mono
      maple-mono.NF-unhinted
      maple-mono.truetype
      nerd-fonts.jetbrains-mono
    ]);
}
