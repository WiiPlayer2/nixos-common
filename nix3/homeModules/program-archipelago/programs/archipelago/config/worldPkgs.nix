{ pkgs }:
with pkgs;
let
  fetchWorld =
    {
      name,
      url,
      hash,
      meta ? { inherit name; },
    }:
    let
      src = fetchurl {
        inherit url hash;
      };
      world =
        runCommand "${name}-apworld"
          {
            inherit meta;
            passthru = {
              inherit src;
            };
          }
          ''
            mkdir -p $out
            ln -sf ${src} "$out/${meta.name}.apworld"
          '';
    in
    world;
in
{
  Twilight_Princess =
    let
      src = fetchzip {
        url = "https://github.com/WritingHusky/Twilight_Princess_apworld/releases/download/v0.3.0/Twilight_Princess_apworld-v0.3.0.zip";
        hash = "sha256-h5tnlySZtaiAQODF27KJgPfWF9JueGDyddhD2PP0Pm8=";
        stripRoot = false;
      };
      world =
        runCommand "twilight-princess-apworld"
          {
            passthru = {
              inherit src;
            };
            meta.name = "Twilight Princess";
          }
          ''
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
      world =
        runCommand "the-minish-cap-apworld"
          {
            passthru = {
              inherit src;
            };
            meta.name = "tmc";
          }
          ''
            mkdir -p $out
            ln -sf ${src} $out/tmc.apworld
          '';
    in
    world;

  Metroid_Prime =
    let
      src = fetchurl {
        url = "https://github.com/UltiNaruto/MetroidAPrime/releases/download/v0.5.4-h1/metroidprime.apworld";
        hash = "sha256-ERN1jEGP4iVXgWvz3d4+nlG1p7JQH10avlPjQjTiGeU=";
      };
      world =
        runCommand "metroid-prime-apworld"
          {
            passthru = {
              inherit src;
            };
            meta.name = "metroidprime";
          }
          ''
            mkdir -p $out
            ln -sf ${src} $out/metroidprime.apworld
          '';
    in
    world;

  Phantom_Hourglass = fetchWorld {
    name = "phantom-hourglass";
    url = "https://github.com/carrotinator/Archipelago/releases/download/ph-v0.9.3-alpha/tloz_ph.apworld";
    hash = "sha256-/Y2LPR7JBKZNzFc1qBHcHvbVAJVggyp25g21YtQJpNk=";
    meta.name = "tloz_ph";
  };

  Spirit_Tracks = fetchWorld {
    name = "spirit-tracks";
    url = "https://github.com/DayKat/spirit-tracks/releases/download/st-v0.7.7/tloz_st.apworld";
    hash = "sha256-7LCeuOcF4GYSY/ZIPoOagOLgwflPaffNWMGwtkyPkD4=";
    meta.name = "tloz_st";
  };

  A_Link_Between_Worlds = fetchWorld {
    name = "a-link-between-worlds";
    url = "https://github.com/randomsalience/albw-archipelago/releases/download/v0.2.3/albw.apworld";
    hash = "sha256-p1bJ+9e30sJCiicqIT2XNrao0v/XNSZXB3X8sdprQ9s=";
    meta.name = "albw";
  };

  Tracker = fetchWorld {
    name = "tracker";
    url = "https://github.com/FarisTheAncient/Archipelago/releases/download/Tracker_v0.2.32/tracker.apworld";
    hash = "sha256-iLyqOOToCWnhxK0u9QmhH+In9gQ6YgRO+L2Z3jeyKfc=";
    meta.name = "tracker";
  };
}
