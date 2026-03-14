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
          };
        };
      };
    };
  };
}
