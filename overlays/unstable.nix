{ lib, inputs, ... }:
with lib;
{
  flake.overlays.unstable =
    final: prev:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev)
          system
          config
          ;
      };
      refPkgs = [
        # "firefoxpwa"
        # "jetbrains"
        # "archipelago"
        # # "modemmanager"
        # # "poptracker" # see overrides
        # "llama-cpp"
        # "ayugram-desktop"
        # # "opencode"
        # "llama-cpp"
      ];
      scopePkgs = [
        # "phoc"
        # # "phosh"
        # # "phosh-mobile-settings"
      ];
      refPkgs' = genAttrs refPkgs (name: unstable.${name});
      scopePkgs' = genAttrs scopePkgs (name: final.callPackage unstable.${name}.override { });
    in
    refPkgs'
    // scopePkgs'
    // {
      # phosh = final.callPackage unstable.phosh.override {
      #   inherit (unstable)
      #     modemmanager
      #     gmobile
      #     ;
      # };
      # phosh-mobile-settings = final.callPackage unstable.phosh-mobile-settings.override {
      #   inherit (unstable)
      #     modemmanager
      #     gmobile
      #     ;
      # };
      # sunshine = unstable.sunshine.override {
      #   boost = unstable.boost187;
      # };

      # opencode = unstable.opencode.overrideAttrs (prevAttrs: {
      #   # nativeBuildInputs = [
      #   #   unstable.breakpointHook
      #   # ];
      #   patches = prevAttrs.patches or [ ] ++ [
      #     # ref: https://github.com/anomalyco/opencode/pull/13234
      #     # ./patches/opencode-models-endpoint.patch

      #     # ref: https://github.com/anomalyco/opencode/pull/15018
      #     # (final.fetchpatch {
      #     #   url = "https://patch-diff.githubusercontent.com/raw/anomalyco/opencode/pull/15018.patch";
      #     #   hash = "sha256-L3pcvqQrb/AHkOFvyFLrWwea4DQgpjqTQd41kkiYxsk=";
      #     # })
      #   ];
      # });
    };
}
