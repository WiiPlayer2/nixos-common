{ flakeConfig' }:
''
  ${flakeConfig'.pre-commit.installationScript}
  export FLAKE_ROOT="$(pwd)"
''
