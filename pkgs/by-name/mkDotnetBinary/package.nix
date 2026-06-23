{
  buildFHSEnv,
  runCommand,
}:
{
  pname,
  version,
  src,
}:
let
  srcExec = runCommand src.name { } ''
    mkdir -p $out/bin
    cp ${src} $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';
in
buildFHSEnv {
  inherit pname version;
  runScript = "${srcExec}/bin/${pname}";
  targetPkgs =
    pkgs: with pkgs; [
      icu
      openssl
    ];
}
