{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule (finalAttrs: {
  pname = "DotNetMetadataMcpServer";
  version = "2.0.15";
  src = fetchFromGitHub {
    owner = "V0v1kkk";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-nIHoLHc7u2VslNnvB+81auF26MuxNCiuoOZ28IVPuRY=";
  };

  projectFile = "${finalAttrs.pname}/${finalAttrs.pname}.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.sdk_10_0;
  nugetDeps = ./deps.json;

  meta.mainProgram = finalAttrs.pname;
})
