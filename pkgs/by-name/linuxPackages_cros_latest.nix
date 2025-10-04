{ ninelore-monoflake
, ninelore-monoflake-pkgs
, linux_cros_latest
}:

let
  upstreamPackages = ninelore-monoflake-pkgs.linuxPackagesFor linux_cros_latest;
  crossCompiledPackages = ninelore-monoflake-pkgs.linuxPackagesFor linux_cros_latest.cross-compiled;
in
upstreamPackages // {
  cross-compiled = crossCompiledPackages;
  passthru.skipUpdate = true;
}
