{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.lutris;
in
{
  # TODO: for now disable the hosts when using lutris because the launcher will be installed through lutris
  config = mkIf cfg.enable {
    networking.hosts = {
      # https://github.com/an-anime-team/an-anime-game-launcher/issues/264#issuecomment-1768458294
      "0.0.0.0" = [
        # Global version
        # Genshin logging servers (do not remove!)
        "sg-public-data-api.hoyoverse.com"
        "log-upload-os.hoyoverse.com"

        # Some old global logging servers
        "log-upload-os.mihoyo.com"
        "overseauspider.yuanshen.com"

        # Chinese version
        # Genshin logging servers (do not remove!)
        "public-data-api.mihoyo.com"
        "log-upload.mihoyo.com"
      ];
    };
  };
}
