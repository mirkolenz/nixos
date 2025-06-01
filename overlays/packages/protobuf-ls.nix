{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protobuf-language-server";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "lasorda";
    repo = "protobuf-language-server";
    tag = "v${version}";
    hash = "sha256-bDsvByXa2kH3DnvQpAq79XvwFg4gfhtOP2BpqA1LCI0=";
  };

  vendorHash = "sha256-dRria1zm5Jk7ScXh0HXeU686EmZcRrz5ZgnF0ca9aUQ=";

  ldflags = [
    "-s"
    "-w"
  ];
  doCheck = false;

  meta = {
    description = "A language server implementation for Google Protocol Buffers";
    homepage = "https://github.com/lasorda/protobuf-language-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "protobuf-language-server";
  };
}
