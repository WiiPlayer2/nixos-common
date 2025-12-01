{
  lib,
  buildDotnetModule,
  dotnet-aspnetcore,
  nix-update-script,
}:
with lib;
buildDotnetModule rec {
  pname = "davmail-proxy";
  version = "0.1";

  src = fileset.toSource {
    root = ./src;
    fileset = fileset.fromSource (sources.cleanSource ./src);
  };

  projectFile = "davmail-proxy.csproj";
  nugetDeps = ./deps.json; # nix build .#davmail-proxy.fetch-deps
  dotnet-runtime = dotnet-aspnetcore;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=skip"
      "--src-only"
    ];
  };
}
