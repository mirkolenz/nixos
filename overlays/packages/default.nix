{ inputs, self, ... }:
final: prev:
let
  inherit (self.legacyPackages.${system}) mkNixvim;
  customPackages = {
    bibtex2cff = final.callPackage ./bibtex2cff.nix { };
    bibtexbrowser = final.callPackage ./bibtexbrowser.nix { };
    bibtexbrowser2cff = final.callPackage ./bibtexbrowser2cff.nix { };
    hkknx-bin = final.callPackage ./hkknx.nix { };
    hkknx-docker = final.callPackage ./hkknx-docker.nix { };
    neovide-bin = final.callPackage ./neovide.nix { };
    vimr-bin = final.callPackage ./vimr.nix { };
    restic-browser-bin = final.callPackage ./restic-browser.nix { };
    nixvim = mkNixvim "unstable";
    nixvim-unstable = mkNixvim "unstable";
    nixvim-stable = mkNixvim "stable";
  };
  inherit (final.stdenv.hostPlatform) system;
  getPkg = input: inputs.${input}.packages.${system}.default;
in
{
  custom = customPackages;
  arguebuf = getPkg "arguebuf";
  custom-caddy = getPkg "custom-caddy";
  custom-caddy-docker = inputs.custom-caddy.packages.${system}.docker;
  nixfmt = final.nixfmt-rfc-style;
  dummy = final.writeShellScriptBin "dummy" ":";
  mkApp = final.callPackage ./make-app.nix { };
}
// customPackages
