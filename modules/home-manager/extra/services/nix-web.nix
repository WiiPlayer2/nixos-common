{  lib,        config,
  pkgs,
              ...
}:
with lib;
let
  cfg = config.services.nix-web;

  # TODO: check if realpath is in store
  nixWebShow = pkgs.writeShellApplication {
    name = "nix-web-show";
                        text = ''
                          # Uses xdg-open from environment
                          _realpath=$(realpath "$1")
                          echo "$_realpath"
                          xdg-open "http://localhost:8649''${_realpath}"
                        '';
  };
in
{
  options.services.nix-web = {
    enable = mkEnableOption "Whether to enable the nix-web service";
    package = mkOption {
      type = types.package;
      default = pkgs.nix-web;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      nixWebShow
    ];

    systemd.user.services.nix-web = {
      Unit = {
        Description = "nix-web";
      };

      Service = {
        Type = "exec";
        ExecStart = "${getExe cfg.package}";
      };
    };
    systemd.user.sockets.nix-web = {
      Unit = {
        Description = "Socket for nix-web";
      };

      Socket = {
        ListenStream = "0.0.0.0:8649";
      };
    };
  };
}
