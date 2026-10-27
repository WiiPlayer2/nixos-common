{
  fetchurl,

  stdenv,
  # autoPatchelfHook,
  buildFHSEnv,
  runCommand,

  # gmp,
  # zlib,
  # openssl,
}:
buildFHSEnv (
  finalAttrs:
  let
    src =
      {
        "x86_64-linux" = fetchurl {
          url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${finalAttrs.version}/simplex-chat-ubuntu-22_04-x86_64";
          hash = "sha256-WvsdJe/lzPVkoasSS8f0EKenMXHJdKTYt/TY8uPWLnc=";
          # executable = true;
        };
      }
      .${stdenv.hostPlatform.system};
    srcExe = runCommand src.name { } ''
      mkdir --p $out/bin
      cp ${src} $out/bin/simplex-chat
      chmod +x $out/bin/*
    '';
  in
  {
    pname = "simplex-chat";
    version = "7.0.3";
    targetPkgs =
      p: with p; [
        gmp
        zlib
        openssl
      ];
    runScript = "${srcExe}/bin/simplex-chat";
  }
)

# TODO: fix patching, currently doesn't work due to ld.so.cache not found
# stdenv.mkDerivation (finalAttrs: {
#   pname = "simplex-chat";
#   version = "7.0.3";
#   src = {
#     "x86_64-linux" = fetchurl {
#       url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${finalAttrs.version}/simplex-chat-ubuntu-22_04-x86_64";
#       hash = "sha256-WvsdJe/lzPVkoasSS8f0EKenMXHJdKTYt/TY8uPWLnc=";
#     };
#   }.${stdenv.hostPlatform.system};

#   dontUnpack = true;
#   dontStrip = true;

#   nativeBuildInputs = [
#     autoPatchelfHook
#   ];

#   buildInputs = [
#     gmp
#     zlib
#     openssl
#   ];

#   installPhase = ''
#     mkdir -p $out/bin
#     cp $src $out/bin/simplex-chat
#     chmod +x $out/bin/*
#   '';
# })
