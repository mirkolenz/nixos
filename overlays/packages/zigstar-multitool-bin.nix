{
  lib,
  mkApp,
  fetchzip,
}:
mkApp rec {
  pname = "zigstar-multitool";
  version = "0.4.2";
  appname = "ZigStarGW-MT";

  src = fetchzip {
    url = "https://github.com/xyzroe/ZigStarGW-MT/releases/download/v${version}/${appname}.app.zip";
    hash = "sha256-8el7RqCVEHUkNY3JAHRkH9yKCCIRxDDOjR2+WW+zmKQ=";
    stripRoot = false;
  };

  meta = {
    description = "UI wrapper designed for convenient service work with TI CC1352/CC2538/CC2652 based Zigbee sticks or gateways";
    homepage = "https://github.com/xyzroe/ZigStarGW-MT";
    downloadPage = "https://github.com/xyzroe/ZigStarGW-MT/releases";
    license = lib.licenses.gpl3;
  };
}
