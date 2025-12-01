{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.taskwarrior;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tasksh
      taskwarrior-tui
      vit
      tasknc
      taskopen

      # (
      #   let
      #     azure = azure-cli.withExtensions (with azure-cli-extensions; [
      #       azure-devops
      #     ]);
      #   in
      #     writeScriptBin "tw_devops_sync" ''
      #       #!${pkgs.powershell}
      #       $ErrorActionPreference = 'Stop'
      #       Install-Module -Name AzDevOps
      #       # Connect-Organization
      #       Invoke-Endpoint -Uri https://dev.azure.com/{organization}/{project}/{team}/_apis/wit/wiql?api-version=7.1
      #     ''
      # )
      (azure-cli.withExtensions (
        with azure-cli-extensions;
        [
          azure-devops
        ]
      ))
    ];

    programs = {
      taskwarrior = {
        enable = true;
        package = pkgs.taskwarrior3;

        dataLocation = mkIf (cfg.dataLocation != null) cfg.dataLocation;

        config = {
          confirmation = false;
          uda = {
            devopsid = {
              type = "numeric";
              label = "Devops ID";
            };
          };
        };
      };
    };

    my =
      let
        mainUiCommand = "wezterm start vit";
      in
      {
        # disabled due to interval not working
        # components.graphical.windowManager.i3.extraBlocks.taskwarrior.block = {
        #   block = "taskwarrior";
        #   data_location = config.programs.taskwarrior.dataLocation;
        #   format = " $icon $count.eng(w:1) ";
        #   format_singular = " $icon $count.eng(w:1) ";
        #   format_everything_done = " $icon ";
        #   click = [
        #     {
        #       button = "left";
        #       cmd = mainUiCommand;
        #     }
        #   ];
        # };
        # startup.taskwarrior.command = mainUiCommand;
      };
  };
}
