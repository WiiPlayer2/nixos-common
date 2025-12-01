{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.firefox;
in
{
  config = mkIf cfg.enable {
    programs.firefox = {
      nativeMessagingHosts = with pkgs; [
        firefoxpwa
      ];
      profiles.default-release = {
        settings = {
          "network.websocket.allowInsecureFromHTTPS" = true;
          "extensions.autoDisableScopes" = 0;
        };
        # https://nur.nix-community.org/repos/rycee/
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          pwas-for-firefox
          keepassxc-browser
          omnisearch
          i-dont-care-about-cookies
        ];
        search = {
          default = "ddg";
          force = true;
          engines = {
            nix-packages = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "@nw" ];
            };

            nueschtos = {
              name = "NüschtOS";
              urls = [
                {
                  template = "https://search.nüschtos.de";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nm" ];
            };

            noogle = {
              name = "Noogle";
              urls = [
                {
                  template = "https://noogle.dev/q";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            bing.metaData.hidden = true;
            google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
      };
    };

    home.packages = with pkgs; [
      firefoxpwa
    ];
  };
}
