{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  # prefetch-attr .#vimPlugins.copilot-lua.src.url --unpack
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "96e1bb1963f351700bf6737ef3695e8a0b90b12a";
    hash = "sha256-W468TRmW77Yh+RrEsFZbm+CILVOFU8+CmyFgerI4JX4=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
