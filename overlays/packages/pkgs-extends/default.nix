final: prev:
with prev.lib;
let
  linuxPackagesExtension = import ./linuxPackages;
  versions = [
    null
    "7_0"
    "latest"
  ];
in
genAttrs' versions (
  version:
  let
    name = if version == null then "linuxPackages" else "linuxPackages_${version}";
  in
  {
    inherit name;
    value = prev.${name}.extend linuxPackagesExtension;
  }
)
