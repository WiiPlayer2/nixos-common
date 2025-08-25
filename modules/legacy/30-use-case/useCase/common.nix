{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.common;
in
{
  options.my.useCase.common =
    let
      self = config.my.useCase.common;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Common use case for relevant for almost all machines";
      options = {
        dailyDriver = mkSub "Daily driver";
        terminal = mkSub "Terminal";
        timetracking = mkSubGroup {
          description = "Timetracking";
          options =
            let
              self = config.my.useCase.common.timetracking;
              mkSub = mkSubUseCaseOption self;
              mkSubGroup = mkSubGroupUseCaseOption self;
            in
            {
              active = mkSub "Active";
              passive = mkSub "Passive";
            };
        };
        cloudStorage = mkSubGroup {
          description = "Cloud storage access e.g. Dropbox";
          options =
            let
              self = config.my.useCase.common.cloudStorage;
              mkSub = mkSubUseCaseOption self;
              mkSubGroup = mkSubGroupUseCaseOption self;
            in
            {
              dropbox = mkSub "Dropbox";
              onedrive = mkSub "OneDrive";
              rclone = mkSub "Rclone + Browser";
            };
        };
        banking = mkSub "Banking";
      };
    };

  config = mkMerge [
    (mkIf cfg.terminal.enable {
      my.components.terminal.enable = true;
    })
    (mkIf cfg.dailyDriver.enable {
      # TODO: mmigrate components
      my.components = {
        graphical = {
          enable = true;
          windowManager.i3 = {
            enable = true;
            blocks = {
              speedtest.enable = true;
              time.showDate = true;
              flakeUpdates.enable = true;
              notifications.enable = true;
            };
            extraBlocks = {
              weather.enable = true;
              music.enable = true;
            };
          };
          dunst.enable = true;
          social = {
            misc = true;
            element.enable = true;
          };
          development.misc = true;
          cad.enable = true;
        };
        terminal = {
          enable = true;
          development = {
            misc = true;
            pmbootstrap = true;
          };
        };
      };
      my.programs = {
        nemo.enable = true;
        taskwarrior = {
          enable = true;
          dataLocation = "$HOME/Dropbox/Sync/taskwarrior";
        };
        firefox.enable = true;
      };
      my.services = {
        p2p-clipboard.enable = true;
      };
    })
    (mkIf cfg.timetracking.active.enable {
      my.services = {
        # tagtime.enable = true;
      };
    })
    # Don't add yet. Might also be active
    # (mkIf cfg.timetracking.passive.enable {
    #   my.programs = {
    #     wakatime-cli.enable = true;
    #   };
    # })
    (mkIf cfg.cloudStorage.onedrive.enable {
      my.programs = {
        onedrive.enable = true;
      };
    })
    (mkIf cfg.cloudStorage.onedrive.enable {
      my.programs = {
        rclone.enable = true;
        rclone-browser.enable = true;
      };
    })
  ];
}
