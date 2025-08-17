# TODO: this "package" probably needs to go into an overlay or something
final: prev:
{
  hid-spsdm = final.callPackage ./by-name/hid-spsdm.nix { };
}
