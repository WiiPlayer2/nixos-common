{
  fetchurl,

  stdenv,
  unzip,
  strace,
  breakpointHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "junie-cli";
  version = "3419.7";
  src = fetchurl {
    url = "https://github.com/JetBrains/junie/releases/download/3419.7/junie-release-3419.7-linux-amd64.zip";
    sha256 = "7037ad8a4879eb80e1294612350c32d67771ea076a0f85ebf80869508a59b82e";
  };

  nativeBuildInputs = [
    unzip
    strace
    breakpointHook
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out

    cp -r junie-app/. $out
  '';

  meta.mainProgram = "junie";
})
