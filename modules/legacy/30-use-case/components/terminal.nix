{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = with lib; [
    (mkRenamedOptionModule
      [ "my" "components" "terminal" "development" "enable" ]
      [ "my" "components" "terminal" "development" "misc" ]
    )
  ];

  options.my.components.terminal = with lib; {
    enable = mkEnableOption "Whether or not terminal components are enabled";
    development = {
      pmbootstrap = mkEnableOption "Whether pmbootstrap is available";
      misc = mkEnableOption "Whether misc development apps are available";
    };
  };
}
