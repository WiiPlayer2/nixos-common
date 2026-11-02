{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pince
    appimage-run
  ];

  nixpkgs.overlays = [
    (final: prev: {
      dms-shell = prev.dms-shell.override {
        extraQtPackages = [
          # for plugin homeAssistantMonitor
          final.kdePackages.qtwebsockets
        ];
      };
    })
  ];
}
