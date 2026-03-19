{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "html2markdown";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "JohannesKaufmann";
    repo = "html-to-markdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xTfJNijtDlQ5oEZkl92KEyFg3U+Wl4nJcsT5puS7h4A=";
  };

  vendorHash = "sha256-ZU2sZZEmnVrrJb4SAAa4A4sYRtRxMgn5FaK9DByGQ2I=";

  subPackages = [ "./cli/html2markdown" ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  strictDeps = true;

  meta = {
    description = "Convert HTML to Markdown. Even works with entire websites and can be extended through rules";
    homepage = "https://github.com/JohannesKaufmann/html-to-markdown";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "html2markdown";
  };
})
