{ self, lib, ... }:
{
  flake.overlays =
    let
      overlay = lib.fixedPoints.composeManyExtensions [
        self.overlays.legacy
        self.overlays.bubblewrapped
        self.overlays.packages
        self.overlays.overrides
        self.overlays.external
        self.overlays.unstable
      ];
    in
    {
      default = overlay;
      all = overlay;
    };
}
