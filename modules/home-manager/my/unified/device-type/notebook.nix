{ config, lib, ... }:
with lib;
{
  options.unified.device-type.notebook.enable = mkEnableOption "";

  config = mkIf config.unified.device-type.notebook.enable {
    programs.mangohud.settings = {
      ### Display battery information
      battery = true;
    };
  };
}
