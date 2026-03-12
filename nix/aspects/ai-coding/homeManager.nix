_: {
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
      settings.provider = {
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
            qwen3-coder-30b-a3b-instruct.name = "Qwen3-Coder 30B A3B (Instruct)";
            devstral-small.name = "Devstral Small 1.1";
            devstral-small-2-24b-instruct.name = "Devstral Small 2 24B (Instruct)";
            ministral3-3b-reasoning.name = "Ministral 3 3B (Reasoning)";
            ministral3-3b-instruct.name = "Ministral 3 3B (Instruct)";
          };
        };
      };
    };
  };
}
