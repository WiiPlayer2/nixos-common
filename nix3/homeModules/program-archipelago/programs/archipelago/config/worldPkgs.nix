{ pkgs }:
with pkgs;
{
  Twilight_Princess =
    let
      src = fetchzip {
        url = "https://github.com/WritingHusky/Twilight_Princess_apworld/releases/download/v0.3.0/Twilight_Princess_apworld-v0.3.0.zip";
        hash = "sha256-h5tnlySZtaiAQODF27KJgPfWF9JueGDyddhD2PP0Pm8=";
        stripRoot = false;
      };
      world = runCommand "twilight-princess-apworld"
        {
          passthru = {
            inherit src;
          };
          meta.name = "Twilight Princess";
        } ''
        mkdir -p $out
        ln -sf "${src}/Twilight Princess.apworld" $out/
      '';
    in
    world;

  The_Minish_Cap =
    let
      src = fetchurl {
        url = "https://github.com/eternalcode0/Archipelago/releases/download/v0.2.0/tmc.apworld";
        hash = "sha256-vCyeuEoWEr41KhSvtZCEVaoblZSDxdepf5EQrYHqtWo=";
      };
      world = runCommand "the-minish-cap-apworld"
        {
          passthru = {
            inherit src;
          };
          meta.name = "tmc";
        } ''
        mkdir -p $out
        ln -sf ${src} $out/tmc.apworld
      '';
    in
    world;
}
