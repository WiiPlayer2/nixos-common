{
  ninelore-monoflake,
  ninelore-monoflake-pkgs,
  linux_cros_latest,
}:

let
  overrideKernel =
    kernel:
    kernel.overrideAttrs (attrs: {
      passthru = (attrs.passthru or { }) // {
        features = (attrs.passthru.features or { }) // {
          efiBootStub = true;
        };
      };
    });
  upstreamPackages = ninelore-monoflake-pkgs.linuxPackagesFor (overrideKernel linux_cros_latest);
  crossCompiledPackages = ninelore-monoflake-pkgs.linuxPackagesFor (
    overrideKernel linux_cros_latest.cross-compiled
  );
in
upstreamPackages
// {
  cross-compiled = crossCompiledPackages;
  passthru.skipUpdate = true;
}
