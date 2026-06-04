{ pkgs }:
with pkgs;
{
  tmcrando_maptracker_deoxis = fetchurl {
    url = "https://github.com/deoxis9001/tmcrando_maptracker_deoxis/releases/download/stable_v1.0.0.47/StableTmcrTrackerDeoxis.zip";
    hash = "sha256-Wio2aYYv9ZLRtJa1wFD40A14uOlKXgXz/qMQs7jAoyY=";
  };

  TPRAP_poptracker = fetchurl {
    url = "https://github.com/Kizugaya/TPRAP_poptracker/releases/download/v0.10.2/TPRAP_poptracker_v0.10.2.zip";
    hash = "sha256-L0cRhDECB3GYpKQDrkxieVbp16iMbdEIO1E+BK0s8js=";
  };

  MetroidPrimeAP_PopTrackerPack = fetchurl {
    url = "https://github.com/lilDavid/MetroidPrimeAP-PoptrackerPack/releases/download/1.0.3/MetroidPrime-Archipelago-lilDavid.zip";
    hash = "sha256-PP+r9QeoZSW9qeMHC1GSi9y/aW+9QpoQ53+oSK8QBLA=";
  };
}
