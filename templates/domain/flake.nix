{
  inputs = {
    common.url = "github:WiiPlayer2/nixos-common";

    nixpkgs.follows = "common/nixpkgs";
    nixpkgs-unstable.follows = "common/nixpkgs-unstable";

    flake-parts.follows = "common/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      { inherit inputs; }
      { imports = [ ./flake ]; };
}
