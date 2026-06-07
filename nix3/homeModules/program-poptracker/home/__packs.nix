{ pkgs }:
with pkgs;
{
  tmcrando_maptracker_deoxis = fetchurl {
    url = "https://github.com/deoxis9001/tmcrando_maptracker_deoxis/releases/download/stable_v1.0.0.50/StableTmcrTrackerDeoxis.zip";
    hash = "sha256-XZeCnrk+PCYKSCobpONB39vx9+yYv9ESgp7yGYU0w/k=";
  };

  TPRAP_poptracker = fetchurl {
    url = "https://github.com/Kizugaya/TPRAP_poptracker/releases/download/v0.10.2/TPRAP_poptracker_v0.10.2.zip";
    hash = "sha256-L0cRhDECB3GYpKQDrkxieVbp16iMbdEIO1E+BK0s8js=";
  };

  MetroidPrimeAP_PopTrackerPack = fetchurl {
    url = "https://github.com/lilDavid/MetroidPrimeAP-PoptrackerPack/releases/download/1.0.3/MetroidPrime-Archipelago-lilDavid.zip";
    hash = "sha256-PP+r9QeoZSW9qeMHC1GSi9y/aW+9QpoQ53+oSK8QBLA=";
  };

  PH-AP-Item-Tracker = fetchFromGitHub {
    name = "PH-AP-Item-Tracker";
    owner = "ZobeePlays";
    repo = "PH-AP-Item-Tracker";
    rev = "b39b3771566a8907a982f4002dabdb1b74b05816";
    hash = "sha256-hV2cEM4OSwogBveFT8ua9TJNsvxYOthC4CAGJjbqeds=";
  };

  spirit-tracks-poptracker-ap = fetchurl {
    url = "https://github.com/carrotinator/spirit-tracks-poptracker-ap/releases/download/v2.0/spirit_tracks_rail_tracker.zip";
    hash = "sha256-fE2W9JizCzSijczX0vkXpT1KGEDfUZ7tvDFC3l83XyE=";
  };

  ww-poptracker = fetchFromGitHub {
    name = "ww-poptracker";
    owner = "Mysteryem";
    repo = "ww-poptracker";
    rev = "v1.3.0";
    hash = "sha256-7r+kgFpgiOTU47pOcDEec0wnwFimncdR6O3AvWZeb5o=";
  };

  albw-ap-poptracker = fetchurl {
    url = "https://github.com/guigui0246/albw-ap-poptracker/releases/download/1.5.2/albw-ap-poptracker-v1.5.2.zip";
    hash = "sha256-zrxglNSFBhCHVgf6Aqqz6K7UJgn3Ym/d2l0PJi6w5mY=";
  };
}
