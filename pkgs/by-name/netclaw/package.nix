{
  fetchFromGitHub,
  buildDotnetModule,

  dotnet-sdk_10,
  dotnet-aspnetcore_10,
}:
let
  pname = "netclaw";
  version = "0.25.2";
  src = fetchFromGitHub {
    owner = "netclaw-dev";
    repo = "netclaw";
    rev = version;
    hash = "sha256-4wq3xgsEn7X7/c+9TYG82euulaeOz1FL/7JmGGIFbbY=";
  };
in
buildDotnetModule {
  inherit pname version src;

  projectFile = "Netclaw.slnx";
  nugetDeps = ./deps.json; # nix build .#netclaw.fetch-deps
  dotnet-sdk = dotnet-sdk_10;
  dotnet-runtime = dotnet-aspnetcore_10;

  meta.mainProgram = "netclaw";
}
