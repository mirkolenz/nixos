{ pkgs, extras, ... }:
let
  defaults = { ... }: {
    _module.args = { inherit extras; };
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # users.mlenz = import ./home/mlenz.nix;
    users.mlenz = {
      imports = [
        defaults
        ./home/mlenz.nix
      ];
    };
  };
  users = {
    users.mlenz = {
      isNormalUser = true;
      description = "Mirko Lenz";
      group = "mlenz";
      extraGroups = [ "mlenz" "users" "networkmanager" "wheel" "docker" ];
      shell = pkgs.fish;
      packages = with pkgs; [
        nixpkgs-fmt
        nil
        rnix-lsp
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFT0P6ZLB5QOtEdpPHCF0frL3WJEQQGEpMf2r010gYH3 mlenz@mirkos-macbook"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq4FI/+G9JoUDXlUoKEdMtVnhapUScSqGg34r+jLgax mlenz@shellfish"
      ];
      uid = 1000;
      subUidRanges = [
        { count = 1; startUid = 1000; }
        { count = 65536; startUid = 100001; }
      ];
      subGidRanges = [
        { count = 1; startGid = 1000; }
        { count = 65536; startGid = 100001; }
      ];
    };
    groups.mlenz = {
      gid = 1000;
    };
  };
}
