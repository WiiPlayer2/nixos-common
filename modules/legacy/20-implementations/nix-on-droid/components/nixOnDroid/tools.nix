{ config, lib, ... }:
let
  cfg = config.my.components.nixOnDroid.tools;
in
{
  config = with lib; {
    android-integration = {
      termux-wake-lock.enable = cfg.wake-lock.enable;
      termux-wake-unlock.enable = cfg.wake-lock.enable;
      termux-setup-storage.enable = cfg.storage.enable;
      termux-open.enable = cfg.open.enable;
      termux-open-url.enable = cfg.open.enable;
      xdg-open.enable = cfg.open.enable;
      am.enable = cfg.misc.enable;
      termux-reload-settings.enable = cfg.misc.enable;
      unsupported.enable = cfg.misc.enable;
    };
  };
}
