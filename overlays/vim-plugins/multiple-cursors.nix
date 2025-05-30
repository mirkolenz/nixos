{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "multiple-cursors.nvim";
  version = "0.15";
  # prefetch-attr .#vimPlugins.multiple-cursors.src.url --unpack
  src = fetchFromGitHub {
    owner = "brenton-leighton";
    repo = "multiple-cursors.nvim";
    tag = "v${version}";
    hash = "sha256-iTtohxL1uJu/KGGvZsnHfqPLj8EaGy1d30I+lHkJaRE=";
  };
  meta.homepage = "https://github.com/brenton-leighton/multiple-cursors.nvim";
}
