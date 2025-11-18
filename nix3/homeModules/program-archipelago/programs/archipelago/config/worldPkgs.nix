{ pkgs }:
with pkgs;
{
  Twilight_Princess =
    let
      src = fetchurl {
        url = "https://github.com/WritingHusky/Twilight_Princess_apworld/releases/download/v0.3.0/Twilight_Princess_apworld-v0.3.0.zip";
        hash = "sha256-tLZrnsD7S0l4q1KLejzYou2JV6DdHhaOl/3SaQ1KBWM=";
      };
      world = runCommand "twilight-princess.apworld" {
        passthru = { inherit src; };
      } ''
        ln -sf "${src}/Twilight Princess.apworld" $out
      '';
    in
      world;
}
