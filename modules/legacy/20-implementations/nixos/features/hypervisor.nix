{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.features.hypervisor;
  mainUser = config.my.config.mainUser.name;
in
{
  imports = [
    ../../_shared/features/hypervisor/libvirt.nix
  ];

  config = mkIf cfg.enable {
    users.users."${mainUser}".extraGroups = [
      "libvirtd"
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        parallelShutdown = 10;

        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };

      spiceUSBRedirection.enable = true;
    };
  };
}
