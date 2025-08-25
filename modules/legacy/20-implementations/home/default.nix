{
  imports = [
    ./components
    ./features
    ./mixins
    ./programs
    ./services
    ./scripts
    ./useCase

    ./accounts.nix
    ./config.nix
    ./personalization.nix
    ./pkgs.nix
  ];

  systemd.user.startServices = "sd-switch";
}
