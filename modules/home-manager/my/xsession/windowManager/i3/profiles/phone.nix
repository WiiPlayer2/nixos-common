{ lib, config, ... }@inputs:
{
  i3 = {
    bars = {
      top = {
        fonts = {
          names = [
            "Ubuntu"
            "FiraCode Nerd Font"
          ];
          style = "Bold Semi-Condensed";
          size = 20.0;
        };
      };
    };
  };
}
