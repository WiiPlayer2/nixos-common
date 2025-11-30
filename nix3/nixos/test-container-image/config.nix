{ lib, pkgs }:
with lib;
{
  nixpkgs.hostPlatform = "x86_64-linux";
  containerImage = {
    script = ''
      ${getExe pkgs.hello}
    '';
  };
}
