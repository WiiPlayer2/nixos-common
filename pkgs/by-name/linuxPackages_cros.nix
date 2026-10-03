{
  # ninelore-monoflake,
  # ninelore-monoflake-pkgs,
  linux_cros_latest,
  linuxPackagesFor,
}:

let
  # _linuxPackagesFor = ninelore-monoflake-pkgs.linuxPackagesFor;
  _linuxPackagesFor = linuxPackagesFor;
  upstreamPackages = _linuxPackagesFor linux_cros_latest;
  crossCompiledPackages = _linuxPackagesFor linux_cros_latest.cross-compiled;
in
upstreamPackages
// {
  cross-compiled = crossCompiledPackages;
  passthru.skipUpdate = true;
}
