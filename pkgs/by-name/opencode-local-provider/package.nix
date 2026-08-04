{
  fetchFromGitHub,
  runCommand,

  gnused,
}:
let
  pname = "opencode-local-provider";
  version = "0.1.8";
  src = fetchFromGitHub {
    owner = "goniz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-POTngUezyVsx3k8Reg1YiOkGaIX9/N/v6Nw9mAszvaI=";
  };
  pkg = runCommand "${pname}-${version}" {
    inherit pname version src;
    nativeBuildInputs = [
      gnused
    ];
  } ''
    mkdir -p $out
    cp -r $src/* $out/
    chmod +w $out/src/providers
    sed -i 's/import llamaswap from ".\/llamaswap"/import llamaswap from ".\/llamaswap"\nimport generic from ".\/generic"/' $out/src/providers/index.ts
    sed -i 's/llamaswap,/llamaswap,\n  generic,/' $out/src/providers/index.ts
    cp ${./generic.ts} $out/src/providers/generic.ts
  '';
in
pkg
