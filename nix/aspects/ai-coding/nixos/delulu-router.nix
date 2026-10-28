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
        };
      };
      Root.Mux.Providers = {
        auto.Mux.Providers = {
          assistant.Pipeline = {
            Root.Steps = [
              { ModelTemplate.Name = "Assistant: {{#Name}}{{.}}{{/Name}}{{^Name}}{{Id}}{{/Name}}"; }
            ];
            Provider.Group.Providers = [
              {
                Ref = {
                  Name = "local";
                  Route = "qwen3.5-9b_64k";
                };
              }
            ];
          };
          coding.Pipeline = {
            Root.Steps = [
              { ModelTemplate.Name = "Coding: {{#Name}}{{.}}{{/Name}}{{^Name}}{{Id}}{{/Name}}"; }
            ];
            Provider.Group.Providers = [
              {
                Ref = {
                  Name = "local";
                  Route = "qwen3.6-35b-a3b_64k";
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
