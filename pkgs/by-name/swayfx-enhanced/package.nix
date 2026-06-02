{
  inputs,
  hostPlatform,

  sway,

  # Used by the NixOS module:
  withBaseWrapper ? true,
  extraSessionCommands ? "",
  withGtkWrapper ? false,
  extraOptions ? [ ], # E.g.: [ "--verbose" ]
  isNixOS ? false,
  enableXWayland ? true,
  dbusSupport ? true,
}:
let
  swayfx-enhanced-unwrapped =
    inputs.swayfx-enhanced.packages.${hostPlatform.system}.swayfx-unwrapped-git;
in
sway.override {
  inherit
    withBaseWrapper
    extraSessionCommands
    withGtkWrapper
    extraOptions
    isNixOS
    enableXWayland
    dbusSupport
    ;
  sway-unwrapped = swayfx-enhanced-unwrapped;
}
