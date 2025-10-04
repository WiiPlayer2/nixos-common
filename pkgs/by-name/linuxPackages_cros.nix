{ ninelore-monoflake
, ninelore-monoflake-pkgs
, linux_cros
}:

let
  upstreamPackages = ninelore-monoflake-pkgs.linuxPackagesFor linux_cros;
  crossCompiledPackages = ninelore-monoflake-pkgs.linuxPackagesFor linux_cros.cross-compiled;
in
upstreamPackages // {
  cross-compiled = crossCompiledPackages;
  passthru.skipUpdate = true;
}
