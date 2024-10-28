{ inputs, self, ... }:
final: prev:
let
  flakeExposed = {
    bibtex2cff = final.callPackage ./bibtex2cff.nix { };
    bibtexbrowser = final.callPackage ./bibtexbrowser.nix { };
    bibtexbrowser2cff = final.callPackage ./bibtexbrowser2cff.nix { };
    goneovim-bin = final.callPackage ./goneovim.nix { };
    hkknx-bin = final.callPackage ./hkknx.nix { };
    hkknx-docker = final.callPackage ./hkknx-docker.nix { };
    neovide-bin = final.callPackage ./neovide.nix { };
    pam-watchid = final.callPackage ./pam-watchid.nix { };
    restic-browser-bin = final.callPackage ./restic-browser.nix { };
    vimr-bin = final.callPackage ./vimr.nix { };
  };
  inherit (final.stdenv.hostPlatform) system;
in
{
  flake-exposed = flakeExposed;
  arguebuf = inputs.arguebuf.packages.${system}.default;
  custom-caddy = inputs.caddy.packages.${system}.default;
  custom-caddy-docker = inputs.caddy.packages.${system}.docker;
  nixfmt = final.nixfmt-rfc-style;
  dummy = final.writeShellScriptBin "dummy" ":";
  mkApp = final.callPackage ./make-app.nix { };
  inherit (self.packages.${system}) nixvim nixvim-unstable nixvim-stable;
}
// flakeExposed
