{ lib, inputs, ... }:
with lib;
let
  flake-inputs = inputs;
in
{
  flake.overlays.legacy = final: prev: {
    unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
    nix-archipelago =
      if prev.stdenv.hostPlatform.system == "x86_64-linux" then
        flake-inputs.nix-archipelago.packages.${prev.stdenv.hostPlatform.system}
      else
        { archipelago-appimage = null; };
    nixgl = flake-inputs.nixgl.packages.${prev.stdenv.hostPlatform.system};
    # retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs {
    #   src = prev.fetchFromGitHub {
    #     owner = "WiiPlayer2";
    #     repo = "retroarch-joypad-autoconfig";
    #     rev = "8fe0a7f9587abfa7322d5159fab8806844fb3b69";
    #     hash = "sha256-vHiYY8XlUcT/9DFKuSiM/thiEP0ksNNvNALoTYpA0q4=";
    #   };
    # };
    wezterm-unstable = flake-inputs.wezterm.packages.${prev.stdenv.hostPlatform.system}.default;
  };
}
