{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ollama-copilot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bernardo-bruning";
    repo = "ollama-copilot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EVQbYXXBKxcWAHxJgZdgMvBEMlUksZIZ2UG3r31zGaM=";
  };

  vendorHash = "sha256-g27MqS3qk67sve/jexd07zZVLR+aZOslXrXKjk9BWtk=";

  subPackages = [ "." ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

  meta = {
    description = "Proxy that allows you to use ollama as a copilot like Github copilot";
    homepage = "https://github.com/bernardo-bruning/ollama-copilot";
    downloadPage = "https://github.com/bernardo-bruning/ollama-copilot/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "ollama-copilot";
  };
})
