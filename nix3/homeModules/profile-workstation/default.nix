{ lib, config, pkgs, ... }:
with lib;
{
  config = {
    home.packages = with pkgs; [
      logseq
      nix-btm
      nix-tree
      unstable.nix-playground
      unstable.omnix
      k8s-toolbox
      freelens-appimage
      devtoolbox
      clapgrep
      woke
      nbgv
      caligula
      git-sim

      (writeShellApplication {
        name = "k8s-toolbox-rename-pvc";
        runtimeInputs = [
          kubectl
          jq
        ];
        text = builtins.readFile ./__scripts/k8s-toolbox-rename-pvc.sh;
      })
      (writeShellApplication {
        name = "k8s-toolbox-copy-pvc";
        runtimeInputs = [
          kubectl
          jq
        ];
        text = builtins.readFile ./__scripts/k8s-toolbox-copy-pvc.sh;
      })
      (writeShellApplication {
        name = "k8s-toolbox-change-pvc-sc";
        runtimeInputs = [
          kubectl
          jq
          pv-migrate
        ];
        text = builtins.readFile ./__scripts/k8s-toolbox-change-pvc-sc.sh;
      })
    ] ++ (lib.optionals (config.my.features.hypervisor.enable && config.my.features.hypervisor.domains.presets.windows.enable) [
      virt-viewer
      (
        let
          startScript = writeShellScript "vm-windows" ''
            virsh --connect qemu:///system start windows
            ${virt-viewer}/bin/virt-viewer --connect qemu:///system windows
          '';
        in
        makeDesktopItem {
          name = "vm-windows";
          desktopName = "Show windows VM";
          exec = startScript;
        }
      )
    ]);

    programs.direnv.enable = true;

    services = {
      nextcloud-client.enable = true;
      nix-web.enable = true;
    };

    my.startup.kdeconnect.command = "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator";
    my.startup.logseq.command = lib.getExe pkgs.logseq;
  };
}
