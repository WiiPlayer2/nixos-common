{ lib, ... }:
with lib;
let
  programs = [
    "android-studio"
    "android-tools"
    "archipelago"
    "aseprite"
    "atlauncher"
    "attic-client"
    "audacity"
    "blender"
    "bottles"
    "bubbly"
    "cava"
    "clementine"
    "cyanrip"
    "datagrip"
    "delfin"
    "dotnet-sdk"
    "envision"
    "feishin"
    "finamp"
    "firefox"
    "fluxcd"
    "freecad"
    "gamemode"
    "gimp"
    "git"
    "git-repo"
    "godot"
    "heimdall"
    "helmfile"
    "inkscape"
    "k8s-bridge"
    "keyviz"
    "krita"
    "kubecolor"
    "kubernetes-helm"
    "libreoffice"
    "lmms"
    "lutris"
    "mob"
    "nemo"
    "nodejs"
    "obs-studio"
    "onedrive"
    "pmbootstrap"
    "poptracker"
    "presenterm"
    "protontricks"
    "prusa-slicer"
    "rclone"
    "rclone-browser"
    "retroarch"
    "rider"
    "ryujinx"
    "screenkey"
    "shotcut"
    "slides"
    "steam"
    "strawberry"
    "thunderbird"
    "tsrc"
    "tuba"
    "variety"
    "virt-manager"
    "vlc"
    "wakatime-cli"
    "wine"
    "wireshark"
    "wlx-overlay-s"
  ];
  mkProgramOption = description: {
    enable = mkEnableOption description;
  };
  programOptions = listToAttrs (
    map
      (x: {
        name = x;
        value = mkProgramOption x;
      })
      programs
  );
in
{
  options.my.programs = programOptions;
}
