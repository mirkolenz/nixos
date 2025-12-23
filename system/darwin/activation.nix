{ pkgs, lib, ... }:
{
  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/activation-scripts.nix
  system.activationScripts = {
    preActivation.text = /* bash */ '''';
    extraActivation.text = /* bash */ '''';
    postActivation.text = /* bash */ ''
      expected_version="${pkgs.determinate-nix.version}"
      current_version=$(/usr/local/bin/determinate-nixd version | ${lib.getExe pkgs.gawk} '/daemon version:/ {print $NF; exit}')
      if [ "$current_version" != "$expected_version" ]; then
        echo "Determinate Nixd: Upgrading from $current_version to $expected_version"
        /usr/local/bin/determinate-nixd upgrade --version "v$expected_version"
      else
        echo "Determinate Nixd: Already at version $expected_version"
      fi
    '';
  };
}
