{
  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard";

    settings = {
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
}
