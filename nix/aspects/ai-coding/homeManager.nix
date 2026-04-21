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

  modelsLib = import ./_models_lib.nix { inherit lib; };
  toModelConfig =
    id:
    { model, ... }:
    {
      name = id;
      value = {
        name = model.name;
      };
    };
  modelConfigs = mapAttrs' toModelConfig modelsLib.modelVariants;
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
      agents = ./_agents;
      settings = {
        plugin = [
          # "octto@latest" # almost never seems to invoke correctly; plannotator apparently has priority
          # {
          #   "name" = "ralph-wiggum";
          #   "git" = "https://github.com/Th0rgal/opencode-ralph-wiggum.git";
          # }
          "@plannotator/opencode@latest"
          # "@tarquinen/opencode-dcp@latest" # no positive effect found
          # "opencode-pty@latest" # not really used and adds unnecessarily to the context. A MCP server might be more useful.
          # "@howaboua/opencode-chat@latest" # error=libstdc++.so.6: cannot open shared object file
        ];
        permission = {
          bash = {
            "*" = "ask";
            "ls *" = "allow";
            "find *" = "allow";
            "head *" = "allow";
            "tail *" = "allow";
            "grep *" = "allow";
            "cat *" = "allow";
            "wc *" = "allow";
            "awk *" = "allow";
            "dotnet test *" = "allow";
            "dotnet build *" = "allow";
            "git diff *" = "allow";
          };
          # webfetch = "ask"; # Doesn't work for subagents in Rider
        };
        lsp = {
          nixd.command = [ "${getExe pkgs.nixd}" ];
          csharp.command = [ "${getExe pkgs.csharp-ls}" ];
        };
        model = "local/coding";
        provider = {
          nollm = {
            name = "noLLM";
            options.baseURL = "http://localhost:5191/v1";
            models.nollm.name = "noLLM";
          };
          "local" = {
            name = "local";
            options.baseURL = "http://localhost:8090/v1";
            models = {
              coding.name = "Coding";
            }
            // modelConfigs;
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
          "bootstrapper": { "model": "local/coding" },
          "probe": { "model": "local/coding" },
          "octto": { "model": "local/coding" }
        }
      }
    '';
  };
}
