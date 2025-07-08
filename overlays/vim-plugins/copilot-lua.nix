{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  # prefetch-attr .#vimPlugins.copilot-lua.src.url --unpack
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "46f4b7d026cba9497159dcd3e6aa61a185cb1c48";
    hash = "sha256-p4kZBoa0GMV1s4gNfQ3i2ZTVN8RNxOi3EJ7pH6nw6qk=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
