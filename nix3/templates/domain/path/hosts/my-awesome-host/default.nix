{
  hosts.config.my-awesome-host = {
    type = "nixos";
    mainUser = "nixos";
    modules = {
      home-manager = [
        {
          # TODO: add home-manager configuration for mainUser
        }
      ];
      nixos = [
        {
          # TODO: add nixos configuration
        }
      ];
    };
  };
}
