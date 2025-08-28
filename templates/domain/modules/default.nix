{
  flake = {
    globalModules.default = ./global;
    homeModules.default = ./home-manager;
    nixosModules.default = ./nixos;
  };
}
