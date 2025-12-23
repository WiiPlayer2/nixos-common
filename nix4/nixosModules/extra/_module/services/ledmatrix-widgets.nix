{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.ledmatrix-widgets;

  # switch-to-configuration always checks if ExitMainStatus != 0 (hardcoded) to check if service ran successfully
  wrapperScript = pkgs.writeShellApplication {
    name = "ledmatrix-widgets";
    text = ''
      ${getExe cfg.package} "$@" || true
    '';
  };
in
{
  options.services.ledmatrix-widgets = {
    enable = mkEnableOption "Whether the ledmatrix-service should be enabled.";

    package = mkOption {
      type = types.package;
      default = pkgs.ledmatrix-widgets;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    systemd.services.ledmatrix-widgets = {
      after = [ "multi-user.target" ];
      script = "${getExe wrapperScript}";
      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
