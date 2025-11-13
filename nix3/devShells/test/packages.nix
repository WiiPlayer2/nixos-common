{ pkgs }:
with pkgs; [
  (writeShellApplication {
    name = "test-app";
    text = ''
      echo "it works"
    '';
  })
]
