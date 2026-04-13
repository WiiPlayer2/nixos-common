{
  lib,
  buildDotnetModule,
  dotnet-sdk_10,
  dotnet-aspnetcore_10,
  nix-update-script,
}:
with lib;
buildDotnetModule rec {
  pname = "llama-proxy";
  version = "0.1";

  src = fileset.toSource {
    root = ./src;
    fileset = fileset.fromSource (sources.cleanSource ./src);
  };

  projectFile = "llama-proxy.csproj";
  nugetDeps = ./deps.json; # nix build .#davmail-proxy.fetch-deps
  dotnet-sdk = dotnet-sdk_10;
  dotnet-runtime = dotnet-aspnetcore_10;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=skip"
      "--src-only"
    ];
  };
}
