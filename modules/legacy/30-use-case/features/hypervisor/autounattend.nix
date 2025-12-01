{
  pkgs,
  lib,
  ...
}:
with lib;
{
  mkAutoUnattendImage =
    autoUnattendFile:
    let
      binPath = makeBinPath (
        with pkgs;
        [
          # guestfs-tools
          cdrkit
        ]
      );
      autoUnattendImage = pkgs.runCommand "autounattend-image" { } ''
        export PATH=${binPath}:$PATH

        mkdir image
        mkdir $out

        cp ${autoUnattendFile} image/autounattend.xml
        # virt-make-fs --partition=gpt --type=vfat image/ $out/autounattend.img
        mkisofs -iso-level 4 -full-iso9660-filenames -udf -joliet -rock -o $out/autounattend.iso image
      '';
    in
    autoUnattendImage;
}
