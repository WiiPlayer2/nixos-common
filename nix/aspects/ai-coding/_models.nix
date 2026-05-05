{
  "gemma4-26b" = {
    # repo = "unsloth/gemma-4-26B-A4B-it-GGUF";
    # quant = "UD-IQ2_XXS";
    repo = "TeichAI/gemma-4-26B-A4B-it-Claude-Opus-Distill-GGUF";
    quant = "Q3_K_S";
  };
  "ministral3-3b" = {
    repo = "mistralai/Ministral-3-3B-Reasoning-2512-GGUF";
  };
  "qwen3.5-0.8b" = {
    repo = "unsloth/Qwen3.5-0.8B-GGUF";
  };
  "qwen3.5-9b" = {
    repo = "unsloth/Qwen3.5-9B-GGUF";
    quants = [
      null
      "UD-IQ2_XXS"
    ];
  };
  "qwen3.5-35b" = {
    repo = "unsloth/Qwen3.5-35B-A3B-GGUF";
    quant = "UD-IQ2_XXS";
  };
  "qwen3.6-35b" = {
    repo = "unsloth/Qwen3.6-35B-A3B-GGUF";
    quants = [
      "UD-IQ1_M"
      "UD-IQ2_XXS"
      "UD-IQ3_S"
    ];
  };
  "qwen3.6-27b" = {
    repo = "unsloth/Qwen3.6-27B-GGUF";
    quants = [
      "UD-Q3_K_XL"
      "UD-IQ2_XXS"
    ];
  };
  "qwen3-coder-next" = {
    repo = "mradermacher/Qwen3-Coder-Next-REAP-40B-A3B-i1-GGUF";
    quant = "IQ1_S";
  };
  "gpt-oss-20b" = {
    repo = "unsloth/gpt-oss-20b-GGUF";
    quants = [
      null
      "Q2_K"
    ];
  };
}
