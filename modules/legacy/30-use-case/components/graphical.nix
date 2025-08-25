{ pkgs
, lib
, config
, ...
}:
with lib;
let
  mkDefaultEnableOption =
    description:
    mkOption {
      inherit description;
      type = types.bool;
      default = true;
    };
in
{
  imports =
    with lib;
    let
      basePath = [
        "my"
        "components"
        "graphical"
      ];
      rename =
        base: from: to:
        mkRenamedOptionModule (basePath ++ base ++ from) (basePath ++ base ++ to);
    in
    [
      (rename [ "social" ] [ "enable" ] [ "misc" ])
      (rename [ "development" ] [ "enable" ] [ "misc" ])
      (rename [ "windowManager" "i3" ] [ "blocks" "music" "enable" ] [ "extraBlocks" "music" "enable" ])
      (rename [
        "windowManager"
        "i3"
      ] [ "blocks" "weather" "enable" ] [ "extraBlocks" "weather" "enable" ])
      (rename [
        "windowManager"
        "i3"
      ] [ "blocks" "pomodoro" "enable" ] [ "extraBlocks" "pomodoro" "enable" ])
      (mkRenamedOptionModule [ "my" "components" "graphical" "startup" ] [ "my" "startup" ])
    ];

  options.my.components.graphical = with lib; {
    enable = mkEnableOption "Whether or not graphical sessions are available";
    social = {
      misc = mkEnableOption "Whether or not misc social apps are available";
      element = {
        enable = mkEnableOption "Whether Element is available";
      };
      teams = {
        enable = mkEnableOption "Whether Teams is available";
      };
      pidgin = {
        enable = mkEnableOption "Whether Pidgin is available";
      };
      tuba = {
        enable = mkEnableOption "Whether Tuba is available";
      };
    };
    development = {
      misc = mkEnableOption "Whether or not misc development apps are available";
    };
    cad = {
      enable = mkEnableOption "Whether or not CAD apps are available";
    };
    windowManager = {
      i3 = {
        enable = mkEnableOption "Whether window manager i3 is available";
        profile = mkOption {
          description = "The configuration profile used for i3";
          type =
            with types;
            enum [
              "desktop"
              "phone"
            ];
          default = "desktop";
        };
        blocks = {
          diskSpace = {
            path = mkOption {
              description = "The path for which to show the remaining disk space";
              type = types.str;
              default = "/";
            };
          };
          speedtest = {
            enable = mkEnableOption "Whether the speedtest block is enabled";
          };
          time = {
            showDate = mkEnableOption "Whether the date is shown next to the current time";
          };
          moveButtons = {
            enable = mkEnableOption "Whether the move buttons are enabled";
          };
          flakeUpdates = {
            enable = mkEnableOption "Whether a block showing nix flake updates is enabled.";
          };
          notifications = {
            enable = mkEnableOption "Whether a block showing notifications is enabled.";
          };

        };

        extraBlocks = mkOption {
          description = "The configuration of extra blocks";
          type =
            with types;
            attrsOf (submodule {
              options = {
                enable = mkDefaultEnableOption "Whether this block is enabled.";
                block = mkOption {
                  description = "The block configuration";
                  type = types.attrs;
                };
                bar = mkOption {
                  description = "The bar in which this block should appear";
                  type =
                    with types;
                    enum [
                      "top"
                      "bottom"
                    ];
                  default = "top";
                };
                order = mkOption {
                  description = "The order value for this block";
                  type = types.int;
                  default = 0;
                };
              };
            });
          default = { };
        };
      };
    };
    dunst = {
      enable = mkEnableOption "Whether to enable dunst";
    };
  };
}
