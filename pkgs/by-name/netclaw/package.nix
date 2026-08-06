{
  fetchFromGitHub,
  buildDotnetModule,

  dotnet-sdk_10,
  dotnet-aspnetcore_10,
}:
let
  pname = "netclaw";
  version = "0.25.3";
  src = fetchFromGitHub {
    owner = "netclaw-dev";
    repo = "netclaw";
    rev = version;
    hash = "sha256-8dU5BpXj4S6bZTKItIZpr0tB6Nc8KySvcAv9ofdH4/U=";
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
