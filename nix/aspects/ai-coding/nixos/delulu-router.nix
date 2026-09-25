{ pkgs, ... }:
{
  services.delulu-router = {
    enable = true;
    # secretsFile = config.age.secrets.delulu-router-secrets.path;
    settings = {
      Refs = {
        Providers = {
          local.Upstream.BaseUrl = "http://localhost:8090";
          kiryu.Upstream.BaseUrl = "http://kiryu.fritz.box:8090";
          auto.Group.Providers = [
            {
              Pipeline = {
                Root.Steps = [
                  {
                    MapModels.Map = {
                      title.Target = "qwen3.5-0.8b";
                      coding.Target = "qwen3.6-35b";
                    };
                  }
                ];
                Provider.Ref.Name = "kiryu";
              };
            }
            {
              Pipeline = {
                Root.Steps = [
                  {
                    MapModels.Map = {
                      title.Target = "qwen3.5-0.8b";
                      coding.Target = "qwen3.6-35b";
                    };
                  }
                ];
                Provider.Ref.Name = "local";
              };
            }
          ];
        };
      };
      Root.Mux.Providers = {
        auto.Ref.Name = "auto";
        auto-ponytail.InjectSkill = {
          FilePath = "${
            pkgs.fetchFromGitHub {
              # https://github.com/DietrichGebert/ponytail
              owner = "DietrichGebert";
              repo = "ponytail";
              rev = "v4.10.0";
              hash = "sha256-PES5XrSYx0VBXWVHEDRykGy0SAmJfV/luzy8Gfg0aAQ=";
            }
          }/skills/ponytail/SKILL.md";
          Provider.Pipeline = {
            Root.Steps = [
              {
                ModelTemplate.Name = "{{#Name}}{{.}} (Ponytail){{/Name}}";
              }
            ];
            Provider.Ref.Name = "auto";
          };
        };
      };
    };
  };
}
