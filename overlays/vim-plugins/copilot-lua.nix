{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  # prefetch-attr .#vimPlugins.copilot-lua.src.url --unpack
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "5f726c8e6bbcd7461ee0b870d4e6c8a973b55b64";
    hash = "sha256-0vDQU8YC3E+vNTA4YUHEkgp9RSMB51lQRXonJTZyiiE=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
