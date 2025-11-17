{ pkgs }:
with pkgs;
{
  tmcrando_maptracker_deoxis = fetchurl {
    url = "https://github.com/deoxis9001/tmcrando_maptracker_deoxis/releases/download/stable_v1.0.0.46/StableTmcrTrackerDeoxis.zip";
    hash = "sha256-MuQs65K7hdebaGmYNt6j8rHbsK8yOviK63j/+tDKiSU=";
  };

  TPRAP_poptracker = fetchurl {
    url = "https://github.com/Kizugaya/TPRAP_poptracker/releases/download/v0.9.0/TPRAP_poptracker_v0.9.0.zip";
    hash = "sha256-6b1f/bBNs7xURNDY5ysIyICudZ88oaxuB6Zi2IWkXpk=";
  };
}
