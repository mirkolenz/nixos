{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  # prefetch-attr .#vimPlugins.copilot-lua.src.url --unpack
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "c1bb86abbed1a52a11ab3944ef00c8410520543d";
    hash = "sha256-qxHpIsFFLDG/jtk6e1hkOZgDSRA5Q0+DMxxAxckNhIc=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
