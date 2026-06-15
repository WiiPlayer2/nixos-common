{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.firefox;
  mkSearch =
    {
      name,
      template,
      iconUrl,
      iconSize,
      alias,
    }:
    {
      inherit name;
      url = [ { inherit template; } ];
      iconMapObj.${toString iconSize} = iconUrl;
      definedAliases = [ alias ];
    };
in
{
  config = mkIf cfg.enable {
    programs.firefox = {
      nativeMessagingHosts = with pkgs; [
        firefoxpwa
      ];
      profiles.default-release = {
        settings = {
          # To allow e.g. Archipelago client websites to connect to insecure servers (e.g. mine)
          "network.websocket.allowInsecureFromHTTPS" = true;

          # Install addons without user confirmation
          # https://devdoc.net/web/developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Alternative_methods_of_installing_add-ons/Installing_add-ons_in_an_enterprise_environment.html
          "extensions.autoDisableScopes" = 0;
        };
        # https://nur.nix-community.org/repos/rycee/
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          pwas-for-firefox
          keepassxc-browser
          omnisearch
          i-dont-care-about-cookies
          multi-account-containers
        ];
        search = {
          default = "ddg";
          force = true;
          engines = {
            nix-packages = mkSearch {
              name = "Nix Packages";
              template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              iconUrl = "https://search.nixos.org/favicon-96x96.png";
              iconSize = 96;
              alias = "@np";
            };

            nixos-wiki = mkSearch {
              name = "NixOS Wiki";
              template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
              iconUrl = "https://wiki.nixos.org/favicon.ico";
              iconSize = 16;
              alias = "@nw";
            };

            nueschtos = mkSearch {
              name = "NüschtOS";
              template = "https://search.nüschtos.de?query={searchTerms}";
              iconUrl = "https://search.nüschtos.de/favicon.ico";
              iconSize = 48;
              alias = "@nm";
            };

            noogle = mkSearch {
              name = "Noogle";
              template = "https://noogle.dev/q?term={searchTerms}";
              iconUrl = "https://noogle.dev/favicon.png";
              iconSize = 16;
              alias = "@no";
            };

            nuget = mkSearch {
              name = "NuGet Gallery";
              template = "https://www.nuget.org/packages?includeComputedFrameworks=true&prerel=true&q={searchTerms}";
              iconUrl = "https://www.nuget.org/favicon.ico";
              iconSize = 48;
              alias = "@nuget";
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
