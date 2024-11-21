{
  self,
  inputs,
  lib',
  ...
}:
{
  _module.args = {
    nixpkgsArgs = rec {
      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
      overlays = import ../overlays {
        inherit
          self
          inputs
          lib'
          ;
        nixpkgsConfig = config;
      };
    };

    # available during import
    specialModuleArgs = {
      inherit self inputs lib';
    };

    # can be overriden in module
    moduleArgs = {
      stateVersions = {
        linux = "24.11";
        darwin = 4;
        home = "24.11";
      };
      user = {
        name = "Mirko Lenz";
        mail = "mirko@mirkolenz.com";
        login = "mlenz";
        id = 1000;
        # https://github.com/mirkolenz.keys
        sshKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFT0P6ZLB5QOtEdpPHCF0frL3WJEQQGEpMf2r010gYH3"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq4FI/+G9JoUDXlUoKEdMtVnhapUScSqGg34r+jLgax"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQkHnDEuSYvI8WY7Mx73yS/WSLjRZs2tv8TtPREVOtg"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTD8HTidTJM3RLmU+WW7tBlDz6L2x8zoHJhqzA6m3+B"
        ];
      };
    };
  };
}
