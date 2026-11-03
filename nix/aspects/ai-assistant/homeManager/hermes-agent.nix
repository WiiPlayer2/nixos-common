{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkAfter
    hm
    ;
in
{
  home.activation.hermesAgentSetupMutable =
    hm.dag.entryAfter
      [
        "hermesAgentSetup"
      ]
      ''
        $DRY_RUN_CMD rm ${config.services.hermes-agent.hermesHome}/.managed
      '';

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard";

    settings = {
      terminal.cwd = null;

      model = {
        base_url = "http://localhost:5000/v1";
        default = "auto/assistant";
        provider = "local";
        api_mode = "chat_completions";
      };

      providers.local = {
        name = "Local";
        base_url = "http://localhost:5000/v1";
        model = "auto/assistant";
        discover_models = true;
        api_mode = "chat_completions";
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
    hermes-agent.Service.Environment = mkAfter [ "HERMES_MANAGED=" ];
    hermes-backend.Service.Environment = mkAfter [ "HERMES_MANAGED=" ];
  };
}
