{ inputs, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  plannotatorSrc = pkgs.fetchFromGitHub {
    owner = "backnotprop";
    repo = "plannotator";
    rev = "v0.16.6";
    hash = "sha256-reTdgjaXZzRG2uE8sMUj7vWpoq8f+secMFK2sGMP/Oo=";
  };
in
{
  imports = [
    inputs.self.homeModules.services-opencode
  ];

  home.packages = with pkgs; [
    uv
    openspec
  ];

  programs = {
    mcp = {
      enable = true;
      servers = {
        # everything = {
        #   command = "npx";
        #   args = [
        #     "-y"
        #     "@modelcontextprotocol/server-everything"
        #   ];
        # };
        openspec = {
          command = getExe' pkgs.nodejs_22 "npx";
          args = [
            "-y"
            "openspec-mcp"
            # "--with-dashboard" # invoke manually with --dashboard in directory
          ];
        };
      };
    };

    opencode = {
      enable = true;
      enableMcpIntegration = true;
      # web = {
      #   enable = true;
      #   extraArgs = [
      #     "--port"
      #     "4090"
      #     "--print-logs"
      #     "--log-level"
      #     "INFO"
      #   ];
      # };
      skills = {
        plannotator-compound = "${plannotatorSrc}/apps/skills/plannotator-compound";
      };
      # TODO: apparently the commands may only be direct paths (e.g. located in the repo)
      # readFile might also work even though it's technically IOD which is bad mojo
      commands = {
        plannotator-annotate = builtins.readFile "${plannotatorSrc}/apps/opencode-plugin/commands/plannotator-annotate.md";
        plannotator-archive = builtins.readFile "${plannotatorSrc}/apps/opencode-plugin/commands/plannotator-archive.md";
        plannotator-last = builtins.readFile "${plannotatorSrc}/apps/opencode-plugin/commands/plannotator-last.md";
        plannotator-review = builtins.readFile "${plannotatorSrc}/apps/opencode-plugin/commands/plannotator-annotate.md";
      };
      # rules = ''
      #   If openspec is configured in this repository ensure that all adjustions are made via the openspec workflow.

      #   Always review openspec artifacts with plannotator.
      # '';
      settings = {
        plugin = [
          "octto@latest"
          # {
          #   "name" = "ralph-wiggum";
          #   "git" = "https://github.com/Th0rgal/opencode-ralph-wiggum.git";
          # }
          "@plannotator/opencode@latest"
          "@tarquinen/opencode-dcp@latest"
          "opencode-pty@latest"
          # "@howaboua/opencode-chat@latest" # error=libstdc++.so.6: cannot open shared object file
        ];
        permission = {
          # bash = "ask"; # NOTE: If there is a way to allow certain patterns it would be better
          # webfetch = "ask"; # Doesn't work for subagents in Rider
        };
        model = "local/coding";
        provider = {
          nollm = {
            npm = "@ai-sdk/openai-compatible";
            name = "noLLM";
            options.baseURL = "http://localhost:5191/v1";
            models.nollm.name = "noLLM";
          };
          "local" = {
            npm = "@ai-sdk/openai-compatible";
            name = "local";
            options.baseURL = "http://localhost:8090/v1";
            models = {
              coding.name = "Default Coding Model";
              qwen35-35b-a3b.name = "Qwen3.5 35B A3B";
              qwen35-122b-a10b.name = "Qwen3.5 122B A10B";
              ministral3-3b-reasoning.name = "Ministral3 3B (Reasoning)";
              gemma4-26b-a4b.name = "Gemma4 26B A4B";
            };
          };
        };
      };
    };
  };

  services = {
    opencode = {
      enable = true;
      restartTriggers = [
        config.xdg.configFile."opencode/octto.json".source
      ];
    };
  };

  xdg.configFile = {
    "opencode/octto.json".text = ''
      {
        "agents": {
          "bootstrapper": { "model": "llama-swap/qwen35-35b-a3b" },
          "probe": { "model": "llama-swap/qwen35-35b-a3b" },
          "octto": { "model": "llama-swap/qwen35-35b-a3b" }
        }
      }
    '';
  };
}
