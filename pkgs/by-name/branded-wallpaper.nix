{
  nixos-artwork,
  runCommand,
  imagemagick,
  inkscape,
  fetchurl,
  nix-update-script,
}:
let
  baseWallpaper = nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath;
  brandLogo = fetchurl {
    url = "https://www.bluehands.de/fileadmin/user_upload/bilder/logos/bluehands-logo.svg";
    hash = "sha256-u2STQfbmmOB6daDl1TqbIm1pa+QStXXopggt5xsGs7Y=";
  };
in
runCommand "branded-wallpaper.png"
  {
    # needed for nix-update
    version = "none";
    src = brandLogo;

    buildInputs = [
      imagemagick
      inkscape
    ];

    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=skip" ];
    };
  }
  ''
    mkdir -p $out

    inkscape \
      --actions="select-all; object-set-property:fill,white;" \
      -h 200 ${brandLogo} -o logo.png
    magick ${baseWallpaper} -gravity SouthEast -draw 'image SrcOver 200,200,0,0 logo.png' $out/wallpaper.png
  ''
