{
  fetchzip,
  symlinkJoin,

  stdenv,
  buildFHSEnv,
  autoPatchelfHook,

  libgcc,
  lttng-ust_2_12,
}:
let
  pname = "netclaw";
  version = "0.23.0";

  client-bin = fetchzip {
    url = "https://github.com/netclaw-dev/netclaw/releases/download/${version}/netclaw-${version}-linux-x64.tar.gz";
    hash = "sha256-EOj1F3q9AXe+6p+txiMjztdGfnerqKKFxz2DFX0bBk4=";
  };
  daemon-bin = fetchzip {
    url = "https://github.com/netclaw-dev/netclaw/releases/download/${version}/netclawd-${version}-linux-x64.tar.gz";
    hash = "sha256-qSODby+9nFkNShR+uz615zhSp9MEXeB1vDFBpGyCspE=";
  };

  stdenv-pkg = stdenv.mkDerivation {
    inherit pname version;

    src = ./.;
    sourceRoot = ".";

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      libgcc.lib
    ];

    runtimeDependencies = [
      lttng-ust_2_12
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${client-bin}/* $out/bin/
      cp ${daemon-bin}/* $out/bin/
    '';
  };

  fhs-pkg =
    let
      mkBin =
        { name, runScript }:
        buildFHSEnv {
          inherit name runScript;
          targetPkgs =
            pkgs: with pkgs; [
              icu78
              openssl
            ];
        };
      client = mkBin {
        name = "netclaw";
        runScript = "${client-bin}/netclaw";
      };
      daemon = mkBin {
        name = "netclawd";
        runScript = "${daemon-bin}/netclawd";
      };
    in
    symlinkJoin {
      inherit pname version;
      paths = [
        client
        daemon
      ];
    };
in
fhs-pkg
