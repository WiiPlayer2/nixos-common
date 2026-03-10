{
  pkgs,
  ninelore-monoflake,
  ninelore-monoflake-input,
  hostPlatform,
  ...
}@args:
let
  mkKernel = pkgs: pkgs.callPackage ./linuxPkg.nix args;
  upstreamKernel = mkKernel pkgs;
  crossCompiledKernel =
    let
      pkgsCross = import ninelore-monoflake-input.inputs.nixpkgs {
        localSystem = "x86_64-linux";
        crossSystem = hostPlatform.system;
      };
      crossPkg = mkKernel pkgsCross;
    in
    crossPkg;
in
upstreamKernel
// {
  cross-compiled = crossCompiledKernel;
  passthru.skipUpdate = true;
}
