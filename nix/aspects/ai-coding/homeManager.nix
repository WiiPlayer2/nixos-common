_:
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
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
              qwen3-coder-30b = {
                name = "Qwen3 Coder 30B";
                # limit = {
                #   context = 48 * 1024;
                #   output = 0;
                #   input = 0;
                # };
              };
              ministral3-3b.name = "Ministral 3 3B";
              ministral3-3b-reasoning.name = "Ministral 3 3B (Reasoning)";
              devstral-small-2-24b.name = "Devstral Small 2 24B";
            };
          };
        };
      };
    };
  };
}
