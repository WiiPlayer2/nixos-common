{ lib
, runCommand
, amnesia
,
}:
runCommand "age-plugin-${amnesia.name}"
{
  buildInputs = [
    amnesia
  ];

  meta.mainProgram = "age-plugin-amnesia";
} ''
  mkdir -p $out/bin
  ln -sf ${lib.getExe amnesia} $out/bin/age-plugin-amnesia
''
