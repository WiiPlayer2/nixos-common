{ config' }:
''
  ${config'.pre-commit.installationScript}
  export FLAKE_ROOT="$(pwd)"
''
