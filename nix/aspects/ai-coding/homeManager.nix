_:
{ pkgs, ... }:
{
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
          command = "npx";
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
      settings = {
        plugin = [
          "octto@latest"
          # {
          #   "name" = "ralph-wiggum";
          #   "git" = "https://github.com/Th0rgal/opencode-ralph-wiggum.git";
          # }
          "@plannotator/opencode"
          "@tarquinen/opencode-dcp@latest"
          "opencode-pty@latest"
        ];
        # command = {
        #   "openspec-mcp-dashboard" = {
        #     description = "Open the Openspec MCP dashboard. (hacky)";
        #     subtask = true;
        #   };
        # };
        permission = {
          # bash = "ask"; # NOTE: If there is a way to allow certain patterns it would be better
          webfetch = "ask";
        };
        provider = {
          nollm = {
            npm = "@ai-sdk/openai-compatible";
            name = "noLLM";
            options.baseURL = "http://localhost:5191/v1";
            models.nollm.name = "noLLM";
          };
          "llama-swap" = {
            npm = "@ai-sdk/openai-compatible";
            name = "llama-swap (local)";
            options.baseURL = "http://localhost:8090/v1";
            models = {
              qwen3-coder-30b.name = "Qwen3 Coder 30B";
              qwen35-35b-a3b.name = "Qwen3.5 35B A3B";
              qwen35-122b-a10b.name = "Qwen3.5 122B A10B";
              ministral3-3b.name = "Ministral3 3B";
              ministral3-3b-reasoning.name = "Ministral3 3B (Reasoning)";
              devstral-small-2-24b.name = "Devstral Small 2 24B";
            };
          };
        };
      };
    };
  };

  home.file = {
    ".config/opencode/octto.json".text = ''
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
