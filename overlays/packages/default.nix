{ inputs, self, ... }:
final: prev:
let
  inherit (final.stdenv.hostPlatform) system;
  flake-exports = {
    bibtex2cff = final.callPackage ./bibtex2cff.nix { };
    bibtexbrowser = final.callPackage ./bibtexbrowser.nix { };
    bibtexbrowser2cff = final.callPackage ./bibtexbrowser2cff.nix { };
    goneovim-bin = final.callPackage ./goneovim.nix { };
    hkknx-bin = final.callPackage ./hkknx.nix { };
    hkknx-docker = final.callPackage ./hkknx-docker.nix { };
    neohtop-bin = final.callPackage ./neohtop.nix { };
    neovide-bin = final.callPackage ./neovide.nix { };
    pam-watchid = final.callPackage ./pam-watchid.nix { };
    restic-browser-bin = final.callPackage ./restic-browser.nix { };
    vimr-bin = final.callPackage ./vimr.nix { };
  };
in
{
  inherit flake-exports;
  inherit (self.packages.${system}) nixvim nixvim-unstable nixvim-stable;
  arguebuf = inputs.arguebuf.packages.${system}.default;
  custom-caddy = inputs.caddy.packages.${system}.default;
  custom-caddy-docker = inputs.caddy.packages.${system}.docker;
  nixfmt = final.nixfmt-rfc-style;
  dummy = final.writeShellScriptBin "dummy" ":";
  mkApp = final.callPackage ./make-app.nix { };
}
// flake-exports
