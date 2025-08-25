{ lib, ... }:
{
  options.my.components.nixOnDroid = with lib; {
    tools = {
      wake-lock = {
        enable = mkEnableOption "Whether the termux wakelock tools should be installed.";
      };
      storage = {
        enable = mkEnableOption "Whether the termux storage tools should be installed.";
      };
      open = {
        enable = mkEnableOption "Whether the termux open tools should be installed.";
      };
      misc = {
        enable = mkEnableOption "Whether other termux tools are available";
      };
    };
  };
}
