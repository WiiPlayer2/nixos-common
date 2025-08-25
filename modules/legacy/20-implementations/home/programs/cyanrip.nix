{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.cyanrip;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cyanrip
      (writeShellApplication {
        name = "rip-cd";
        text = ''
          cyanrip -o flac -D "{album_artist}/{album}" -F "{if #totaldiscs# > #1#|disc|.}{track} {artist} - {title}" -s 0 -Q "$@"
        '';
      })
    ];
  };
}
