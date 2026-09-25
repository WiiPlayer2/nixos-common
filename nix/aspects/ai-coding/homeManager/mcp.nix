{ lib, pkgs, ... }:
let
  inherit (lib)
    getExe
    getExe'
    ;
in
{
  programs.mcp = {
    enable = true;
    servers = {
      openspec = {
        disabled = true; # I think it works worse than just the openspec files, commands and skills
        command = getExe' pkgs.nodejs_22 "npx";
        args = [
          "-y"
          "openspec-mcp"
          # "--with-dashboard" # invoke manually with --dashboard in directory
        ];
      };
      nixos = {
        disabled = true;
        command = getExe pkgs.mcp-nixos;
      };
      dotnet-types-explorer = {
        command = getExe pkgs.dotnet-metadata-mcp-server;
        args = [
          "--homeEnvVariable"
          "$HOME"
        ];
      };
    };
  };
}
