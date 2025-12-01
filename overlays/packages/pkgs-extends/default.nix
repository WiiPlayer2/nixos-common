final: prev:
let
  linuxPackages = import ./linuxPackages;
in
{
  linuxKernel = prev.linuxKernel // {
    packages =
      let
        lpkgs = prev.linuxKernel.packages;
      in
      lpkgs
      // {
        linux_6_16 = lpkgs.linux_6_16.extend linuxPackages;
      };
  };
  linuxPackages_latest = prev.linuxPackages_latest.extend linuxPackages;
}
