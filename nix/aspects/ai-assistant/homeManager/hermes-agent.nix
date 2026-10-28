{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkAfter
    hm
    ;
in
{
  home = {
    packages = with pkgs; [
      simplex-chat
    ];

    activation.hermesAgentSetupMutable =
      hm.dag.entryAfter
        [
          "hermesAgentSetup"
        ]
        ''
          $DRY_RUN_CMD rm ${config.services.hermes-agent.hermesHome}/.managed
        '';
  };

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard";

    environment = {
      SIMPLEX_WS_URL = "ws://127.0.0.1:5225";
    };

    settings = {
      terminal.cwd = null;

      model = {
        default = "auto/assistant";
        base_url = "http://localhost:5000/v1";
      };

      skills.disabled = [
        "airtable"
        "ascii-video"
        "baoyu-infographic"
        "box"
        "claude-code"
        "claude-design"
        "codex"
        "competitor-news-monitor"
        "design-md"
        "github"
        "google-workspace"
        "himalaya"
        "notion"
        "obsidian"
        "p5js"
        "python-debugpy"
        "songwriting-and-ai-music"
        "teams-meeting-pipeline"
        "xurl"
      ];
    };
  };

  systemd.user.services = {
    simplex-chat = {
      Install.WantedBy = [ "default.target" ];
      Service.ExecStart = "${getExe pkgs.simplex-chat} -p 5225";
    };

    hermes-agent.Service.Environment = mkAfter [ "HERMES_MANAGED=" ];
    hermes-backend.Service.Environment = mkAfter [ "HERMES_MANAGED=" ];
  };
}
