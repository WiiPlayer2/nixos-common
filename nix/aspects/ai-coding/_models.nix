{
  "qwen3.5-0.8b".repo = "unsloth/Qwen3.5-0.8B-GGUF";
  "qwen3.5-9b".repo = "unsloth/Qwen3.5-9B-GGUF";
  "qwen3.6-27b" = {
    repo = "unsloth/Qwen3.6-27B-GGUF";
    quants = [
      "UD-Q3_K_XL"
      "UD-IQ2_XXS"
    ];
  };
  "qwen3.6-35b" = {
    repo = "unsloth/Qwen3.6-35B-A3B-GGUF";
    quants = [
      "UD-IQ1_M"
      "UD-IQ2_XXS"
      "UD-IQ3_S"
    ];
  };
}
