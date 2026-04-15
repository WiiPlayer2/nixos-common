{ inputs, ... }:
{ lib, pkgs, ... }:
with lib;
let
  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };

  modelsLib = import ./_models_lib.nix { inherit lib; };
  toModelConfig =
    id:
    { quant, model, ... }:
    {
      name = id;
      value = {
        repo = model.repo;
        ${if quant != null then "quant" else null} = quant;
      };
    };
  modelConfigs = mapAttrs' toModelConfig modelsLib.modelVariants;
in
{
  imports = [
    inputs.self.nixosModules.service-llama-swap
  ];

  environment.systemPackages = [
    llama-cpp
    pkgs.llama-proxy
  ]
  ++ (with pkgs; [
    python312Packages.huggingface-hub
  ]);

  services = {
    llama-swap = {
      enable = true;
      port = 8090;
      settings = {
        healthCheckTimeout = 5 * 60; # 5min
        globalTTL = 15 * 60; # 15min
        sendLoadingState = true;
        includeAliasesInList = true;
        models = {
          "qwen3.5-35b".aliases = [
            "coding"
            "rider-core"
          ];
          "qwen3.5-0.8b".aliases = [
            "small"
            "rider-instant"
          ];
          # "gemma4-26b".aliases = [ "rider-core" ];
        };
        groups.persistent = {
          persistent = true;
          swap = false;
          exclusive = false;
          members = [
            "qwen35-1b"
          ];
        };
      };

      llama-server = {
        package = llama-cpp;
        defaults = {
          contextSize = mkDefault (64 * 1024);
          commandPrefix = "${getExe pkgs.llama-proxy} --port \${PORT} --";
          dynamicPort = false;
          additionalArgs = [
            "--port"
            "__PORT__"
          ];
        };
        models = modelConfigs;
      };
    };
  };
}
