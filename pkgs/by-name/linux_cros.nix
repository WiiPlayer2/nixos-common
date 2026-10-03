{
  # ninelore-monoflake,
  # ninelore-monoflake-input,
  # system,
  linux_cros_latest,
  ...
}@args:
linux_cros_latest.override args
# let
#   upstreamKernel = ninelore-monoflake.linux_cros_latest.override args;
#   crossCompiledKernel =
#     let
#       pkgsCross = import ninelore-monoflake-input.inputs.nixpkgs {
#         localSystem = "x86_64-linux";
#         crossSystem = system;
#       };
#       crossPkg = pkgsCross.callPackage (ninelore-monoflake-input + "/pkgs/linux_cros_latest") args;
#     in
#     crossPkg;
# in
# upstreamKernel
# // {
#   cross-compiled = crossCompiledKernel;
#   passthru.skipUpdate = true;
# }
