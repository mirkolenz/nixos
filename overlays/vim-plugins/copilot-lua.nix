{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "c62a2a7616a9789a7676b6b7a8d9263b1082cdc8";
    hash = "sha256-/uvj0DvO/5iHUuJx3NlpyFc0jC7kq/d1Uk/zQfDv66k=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
