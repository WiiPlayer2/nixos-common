{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pince
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
