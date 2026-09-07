{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lshw
    pciutils
    (pkgs.callPackage ./_scripts/nix-cleanup.nix { })
  ];
}
