{
  self,
  inputs,
  lib',
  ...
}:
{
  _module.args = {
    # available during import
    specialModuleArgs = {
      inherit self inputs lib';
    };

    # can be overriden in module
    moduleArgs = {
      stateVersions = {
        linux = "25.11";
        darwin = 6;
        home = "25.11";
      };
      user = {
        name = "Mirko Lenz";
        mail = "mirko@mirkolenz.com";
        login = "mlenz";
        # https://github.com/mirkolenz.keys
        sshKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFT0P6ZLB5QOtEdpPHCF0frL3WJEQQGEpMf2r010gYH3 mlenz@mirkos-macbook"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTD8HTidTJM3RLmU+WW7tBlDz6L2x8zoHJhqzA6m3+B mlenz@1password"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq4FI/+G9JoUDXlUoKEdMtVnhapUScSqGg34r+jLgax mlenz@shellfish"
        ];
      };
    };
  };
}
