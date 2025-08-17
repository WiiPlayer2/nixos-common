{ bubblewrap
, gnused

, lib
, writeShellApplication
, runCommand
}:
let
  linkDirectories = [
    "share/applications"
    "share/icons"
    "share/pixmaps"
  ];
in
{ package
, name ? package.name
, program ? package.meta.mainProgram

, bindNixStore ? true
, binds ? [ ]

, extraArgs ? [ ]
, extraArgsRaw ? [ ]
}:
let
  mkBindArgs =
    { path
    , target ? path
      # ro, rw, dev
    , type ? "ro"
    , escape ? true
    , quote ? true # only if not escaped
    }:
    let
      mkPathArg =
        path:
        if escape
        then lib.escapeShellArg path
        else if quote then "\"${path}\""
        else path;
    in
    [
      (if type != "rw" then "--${type}-bind" else "--bind")
      (mkPathArg path)
      (mkPathArg target)
    ];

  bindNixStoreBind = lib.optional bindNixStore {
    path = "/nix/store";
  };
  binds' = bindNixStoreBind ++ binds;
  bindsArgs = lib.concatMap mkBindArgs binds';

  bwrapArgs = extraArgs;
  bwrapArgs' = lib.escapeShellArgs bwrapArgs;
  extraArgsRaw' = lib.concatStringsSep " " (bindsArgs ++ extraArgsRaw);
  bwrapArgsRaw = "${bwrapArgs'} ${extraArgsRaw'}";

  wrappedProgram = writeShellApplication {
    name = "${program}-bubblewrapped";
    runtimeInputs = [
      bubblewrap
      package
    ];
    text = ''
      exec bwrap ${bwrapArgsRaw} -- ${package}/bin/${program} "$@"
    '';
  };
  wrappedPackage = runCommand name
    {
      buildInputs = [
        gnused
      ];

      # TODO: for some reason this breaks allowUnfreePredicate
      # meta = package.meta;

      meta.mainProgram = program;
    } ''
    mkdir -p $out/bin
    ln -s ${wrappedProgram}/bin/${wrappedProgram.name} $out/bin/${program}

    ${
      lib.concatStringsSep
      "\n"
      (
        lib.map
        (x: ''
          if [ -e ${package}/${x} ]; then
            mkdir -p $out/${x}
            rmdir $out/${x}
            ln -s ${package}/${x} $out/${x}
          fi
        '')
        linkDirectories
      )
    }
  '';
in
wrappedPackage
