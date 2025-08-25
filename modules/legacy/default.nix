let
  mkModule = subPath: {
    imports = [
      (./20-implementations + "/${subPath}")
      ./30-use-case
      ./40-domain
    ];
  };
in
{
  flake = {
    nixosModules.legacy = mkModule "nixos";
    homeModules.legacy = mkModule "home";
    homeModules.legacy-standalone = mkModule "home-manager/standalone";
    nixOnDroidModules.legacy = mkModule "nix-on-droid";
  };
}
