{ lib, ... }:
with lib;
{
  options.my.programs.taskwarrior = {
    enable = mkEnableOption "Whether taskwarrior is available";
    dataLocation = mkOption {
      description = "The directory where the data should be stored";
      type = with types; nullOr str;
      default = null;
    };
  };
}
