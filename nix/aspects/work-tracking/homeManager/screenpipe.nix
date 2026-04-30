{ lib, pkgs, ... }:
with lib;
{
  home.packages = with pkgs; [
    screenpipe-fhs
  ];

  programs = {
    mcp.servers = {
      screenpipe = {
        disabled = true;
        command =
          let
            script = pkgs.writeShellApplication {
              name = "screenpipe-mcp";
              runtimeInputs = with pkgs; [
                screenpipe-fhs
                nodejs_25
              ];
              text = ''
                SCREENPIPE_LOCAL_API_KEY=$(screenpipe auth token)
                export SCREENPIPE_LOCAL_API_KEY
                npx -y screenpipe-mcp@latest
              '';
            };
          in
          getExe script;
      };
    };

    zsh.initContent = ''
      export SCREENPIPE_LOCAL_API_KEY=$(${getExe pkgs.screenpipe-fhs} auth token)
    '';
  };

  systemd.user.services.screenpipe = {
    Service = {
      Environment = [
        "SCREENPIPE_NO_REMINDERS=1"
      ];
      ExecStart = "${getExe pkgs.screenpipe-fhs} record --disable-telemetry";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
