{ pkgs, ... }:
let
  skill-ponytail = "${
    pkgs.fetchFromGitHub {
      # https://github.com/DietrichGebert/ponytail
      owner = "DietrichGebert";
      repo = "ponytail";
      rev = "v4.10.0";
      hash = "sha256-PES5XrSYx0VBXWVHEDRykGy0SAmJfV/luzy8Gfg0aAQ=";
    }
  }/skills/ponytail/SKILL.md";
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
          junie.Upstream.BaseUrl = "http://localhost:4141";
          local-group.Group.Providers = [
            { Ref.Name = "kiryu"; }
            { Ref.Name = "local"; }
          ];
          auto.Group.Providers = [
            # {
            #   Pipeline = {
            #     Root.Steps = [
            #       {
            #         MapModels.Map = {
            #           title.Target = "claude-sonnet-4-6";
            #           coding.Target = "claude-opus-4-6";
            #         };
            #       }
            #       {
            #         ModelTemplate.Name = "{{Id}} @ Junie";
            #       }
            #     ];
            #     Provider.Ref.Name = "junie";
            #   };
            # }
            {
              Pipeline = {
                Root.Steps = [
                  {
                    MapModels.Map = {
                      title.Target = "qwen3.5-0.8b";
                      coding.Target = "qwen3.8-27b_q2";
                    };
                  }
                ];
                Provider.Ref.Name = "local-group";
              };
            }
          ];
        };
      };
      Root.Mux.Providers = {
        auto.Ref.Name = "auto";
        # auto-ponytail.InjectSkill = {
        #   FilePath = skill-ponytail;
        #   Provider.Pipeline = {
        #     Root.Steps = [
        #       {
        #         ModelTemplate.Name = "{{#Name}}{{.}} (Ponytail){{/Name}}";
        #       }
        #     ];
        #     Provider.Ref.Name = "auto";
        #   };
        # };
        # local-group.Ref.Name = "local-group";
        # local-group-ponytail.InjectSkill = {
        #   FilePath = skill-ponytail;
        #   Provider.Pipeline = {
        #     Root.Steps = [
        #       {
        #         ModelTemplate.Name = "{{#Name}}{{.}} (Ponytail){{/Name}}";
        #       }
        #     ];
        #     Provider.Ref.Name = "local-group";
        #   };
        # };
      };
    };
  };

  systemd.services.delulu-router = {
    restartIfChanged = false;
    stopIfChanged = false;
  };
}
