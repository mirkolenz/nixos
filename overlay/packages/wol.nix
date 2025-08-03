{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "wol";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Trugamr";
    repo = "wol";
    tag = "v${version}";
    hash = "sha256-kiV7DDGmVwJQzGMmvZHmmyz9IUfflbIrvxkIT5bY0Lw=";
  };

  vendorHash = "sha256-DRA9PPNohzUtrIzucVIke5FhGvvA6zRuJzHt0qfB7PA=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trugamr/wol/cmd.version=${version}"
    "-X=github.com/trugamr/wol/cmd.commit=${src.rev}"
    "-X=github.com/trugamr/wol/cmd.date=1970-01-01T00:00:00Z"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wake up your devices with a single command or click, a Wake-On-LAN tool that works via CLI and web interface";
    homepage = "https://github.com/Trugamr/wol";
    downloadPage = "https://github.com/Trugamr/wol/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "wol";
  };
}
