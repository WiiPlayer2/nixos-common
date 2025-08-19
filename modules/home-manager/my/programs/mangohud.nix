{ lib, ... }:
with lib;
{
  # Shift_L+F4 - reload config

  programs.mangohud = {
    enableSessionWide = true;
    settings = {
      ### Display the frametime line graph
      frame_timing = true;

      ### Hud transparency / alpha
      background_alpha = mkForce 0.25; # overrides stylix
      alpha = mkForce 0.75; # overrides stylix

      ### Remove margins around MangoHud
      hud_no_margin = true;

      ### Display MangoHud in a horizontal position
      horizontal = true;

      ### Display GameMode / vkBasalt running status
      # gamemode = true; # always shows "OFF"
    };
  };
}
