{
  imports = [
    ./home-modules.nix
    ./nix-on-droid-modules.nix
  ];

  perSystem =
    {
      inputs',
      self',
      lib,
      pkgs,
      ...
    }:
    {
      formatter = inputs'.nixpkgs-unstable.legacyPackages.nixfmt-tree;
      pre-commit.settings.hooks.nixfmt.enable = true;
    };
}
