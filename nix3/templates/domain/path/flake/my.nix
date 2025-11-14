{ self, inputs, ... }:
{
  imports = [
    inputs.common.flakeModules.default
  ];

  hosts.common = {
    specialArgs = {
      flakeRoot = self.lib.flakeRoot;
    };
    modules = {
      global = [
        self.globalModules.default
      ];
      nixos = [
        self.nixosModules.default
      ];
      home-manager = [
        self.homeModules.default
      ];
    };
  };
}
