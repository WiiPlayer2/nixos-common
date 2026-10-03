{
  # ninelore-monoflake-pkgs,
  linux_cros_latest,
  linuxPackagesFor,
}:

let
  # _linuxPackagesFor = ninelore-monoflake-pkgs.linuxPackagesFor;
  _linuxPackagesFor = linuxPackagesFor;
  overrideKernel =
    kernel:
    kernel.overrideAttrs (attrs: {
      passthru = (attrs.passthru or { }) // {
        features = (attrs.passthru.features or { }) // {
          efiBootStub = true;
        };
      };
    });
  upstreamPackages = _linuxPackagesFor (overrideKernel linux_cros_latest);
  crossCompiledPackages = _linuxPackagesFor (overrideKernel linux_cros_latest.cross-compiled);
in
upstreamPackages
// {
  cross-compiled = crossCompiledPackages;
  passthru.skipUpdate = true;
}
