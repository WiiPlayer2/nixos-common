# TODO: can probably be made better
{
  lib,
  fetchzip,

  writeShellApplication,
  symlinkJoin,
  makeDesktopItem,
  steam-run-free,
}:
with lib;
let
  tool = fetchzip {
    url = "https://github.com/tanjo3/wwrando/releases/download/ap_2.5.1/wwrando_ap-2.5.1-linux.zip";
    hash = "sha256-UZW/SPyKLiUnIgU07aAq42mtVx0OMFgz0kpRdY799S8=";
    stripRoot = false;
    postFetch = ''
      chmod 755 "$out/The Wind Waker Archipelago Randomizer"
    '';
  };
  wrapper = writeShellApplication {
    name = "wwrando-ap";
    runtimeInputs = [
      steam-run-free
    ];
    text = ''
      steam-run "${tool}/The Wind Waker Archipelago Randomizer"
    '';
  };
  desktopItem = makeDesktopItem {
    name = "wwrando-ap";
    desktopName = "The Wind Waker Archipelago Randomizer";
    categories = [
      "Game"
    ];
    exec = "${getExe wrapper}";
  };
  pkg = symlinkJoin {
    name = "wwrando-ap-2.5.1";
    pname = "wwrando-ap";
    version = "s8-v2";
    src = tool;
    paths = [
      wrapper
      desktopItem
    ];
  };
in
pkg
