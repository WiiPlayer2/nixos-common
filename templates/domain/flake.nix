{
  inputs = {
    common.url = "github:WiiPlayer2/nixos-common";

    nixpkgs.follows = "common/nixpkgs";
    nixpkgs-unstable.follows = "common/nixpkgs-unstable";

    flake-parts.follows = "common/flake-parts";
    home-manager.follows = "common/home-manager";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      { inherit inputs; }
      { imports = [ ./flake ]; };
}
