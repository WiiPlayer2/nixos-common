let
  mkPrefixedProvider =
    {
      namePrefix,
      provider,
    }:
    {
      Pipeline = {
        Root.Steps = [
          { ModelTemplate.Name = "${namePrefix}: {{#Name}}{{.}}{{/Name}}{{^Name}}{{Id}}{{/Name}}"; }
        ];
        Provider = provider;
      };
    };

  mkAutoProvider =
    {
      namePrefix,
      providers,
    }:
    mkPrefixedProvider {
      inherit namePrefix;
      provider.Group.Providers = providers;
    };
in
{
  services.delulu-router = {
    enable = true;
    # secretsFile = config.age.secrets.delulu-router-secrets.path;
    settings = {
      Refs = {
        Providers = {
          local.Upstream.BaseUrl = "http://localhost:8090";
          # TODO: check if networking.hostname is kiryu
          kiryu.Upstream.BaseUrl = "http://kiryu.fritz.box:8090";
          local-group.Group.Providers = [
            { Ref.Name = "kiryu"; }
            { Ref.Name = "local"; }
          ];

          auto-local = {
            Mux.Providers = {
              assistant = mkAutoProvider {
                namePrefix = "Local Assistant";
                providers = [
                  {
                    Ref = {
                      Name = "local";
                      Route = "qwen3.5-9b_64k";
                    };
                  }
                ];
              };

              coding = mkAutoProvider {
                namePrefix = "Local Coding";
                providers = [
                  {
                    Ref = {
                      Name = "local";
                      Route = "qwen3.6-35b-a3b_64k";
                    };
                  }
                ];
              };
            };
          };
        };
      };
      Root.Mux.Providers = {
        auto.Mux.Providers = {
          local.Ref.Name = "auto-local";

          assistant = mkAutoProvider {
            namePrefix = "Assistant";
            providers = [
              {
                Ref = {
                  Name = "auto-local";
                  Route = "assistant";
                };
              }
            ];
          };

          coding = mkAutoProvider {
            namePrefix = "Coding";
            providers = [
              {
                Ref = {
                  Name = "auto-local";
                  Route = "coding";
                };
              }
            ];
          };
        };

        local-group.Ref.Name = "local-group";
      };
    };
  };

  systemd.services.delulu-router = {
    restartIfChanged = false;
    stopIfChanged = false;
  };
}
