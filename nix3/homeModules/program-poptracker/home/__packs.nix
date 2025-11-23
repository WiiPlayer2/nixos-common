{ pkgs }:
with pkgs;
{
  tmcrando_maptracker_deoxis = fetchurl {
    url = "https://github.com/deoxis9001/tmcrando_maptracker_deoxis/releases/download/stable_v1.0.0.47/StableTmcrTrackerDeoxis.zip";
    hash = "sha256-Wio2aYYv9ZLRtJa1wFD40A14uOlKXgXz/qMQs7jAoyY=";
  };

  TPRAP_poptracker = fetchurl {
    url = "https://github.com/Kizugaya/TPRAP_poptracker/releases/download/v0.10.0/TPRAP_poptracker_v0.10.0.zip";
    hash = "sha256-JyeJCErIiIOXaSfYyhY3c8Sp5ITQkU4+nUsyO8OVXMY=";
  };

  MetroidPrimeAP_PopTrackerPack = fetchurl {
    url = "https://github.com/lilDavid/MetroidPrimeAP-PoptrackerPack/releases/download/1.0.1/MetroidPrimeAP_PopTrackerPack.zip";
    hash = "sha256-49LZQFWJsWeXY2aVEkL/ygCkRzL8V+PTeiBNUADGtuQ=";
  };
}
