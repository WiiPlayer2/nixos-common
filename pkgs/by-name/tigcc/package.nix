{ fetchzip
, stdenv
, runCommand

, gcc13
, bison
, flex
}:
let
  gcc = gcc13;

  pname = "tigcc";
  version = "0.96-beta8-r1";
  src = fetchzip {
    url = "http://tigcc.ticalc.org/linux/tigcc_src.tar.bz2";
    stripRoot = false;
    hash = "sha256-FWyIrCDVTGTJTmce8CIXDVmjX8Dj3LWyT/bdezC0i78=";
  };
  gcc4-core = fetchzip {
    url = "https://mirror.koddos.net/gcc/releases/gcc-4.1.2/gcc-core-4.1.2.tar.bz2";
    hash = "sha256-B337zB8BZsJHtZi4c0ORSL26sqJ53ot06jQNKRcJ8Ts=";
  };
  binutils = fetchzip {
    url = "https://sourceware.org/pub/binutils/releases/binutils-2.16.1.tar.bz2";
    hash = "sha256-galQzRm20/qwf7c6wFAF9YkFPfWiQpvNWmWyw4nM/CA=";
  };

  prepareStep = { prev, isSrc ? false }: ''
    mkdir -p $out/{src,out}
    _src=$out/src
    _out=$out/out
    ${
      if isSrc
      then "cp -r ${prev}/* $out/src"
      else "cp -r ${prev}/* $out"
    }
    chmod -R 777 $out/*

    export TIGCC="$_out"
    export PATH="$PATH:$TIGCC/bin"
  '';

  step0 = runCommand "${pname}-step0-${version}"
    { } ''
    ${prepareStep { prev = src; isSrc = true; }}

    mkdir -p $_src/download/{gcc.ti,binutils.ti}
    cp -r ${gcc4-core}/* $_src/download/gcc.ti
    cp -r ${binutils}/* $_src/download/binutils.ti
  '';

  step1 = runCommand "${pname}-step1-${version}"
    { } ''
    ${prepareStep { prev = step0; }}

    cd $_src/scripts
    ./Install_step_1

    cd $_src/download/gcc.ti/gcc
    patch -F 5 < ${./gcc.patch}
  '';

  step2 = runCommand "${pname}-step2-${version}"
    {
      buildInputs = [
        gcc
        flex
        bison
      ];
    } ''
    ${prepareStep { prev = step1; }}

    cd $_src/scripts
    ./Install_step_2

    test -f $_out/bin/gcc
  '';

  step3 = runCommand "${pname}-step3-${version}"
    { } ''
    ${prepareStep { prev = step2; }}

    cd $_src/scripts
    # ./Install_step_3
    # pushd and popd for some reason are not found

    echo TIGCC script: Installing TIGCCLIB...
    rm -Rf $TIGCC/include
    cp -Rf ../tigcclib/include  $TIGCC
    pushd $TIGCC/include/asm >/dev/null
    # only symlink if the file system is case sensitive
    if [ ! -f OS.h ]
    then ln -sf os.h OS.h
    fi
    popd >/dev/null
    rm -Rf $TIGCC/lib
    cp -Rf ../tigcclib/lib $TIGCC
    rm -Rf $TIGCC/examples
    cp -Rf ../tigcclib/examples $TIGCC
  '';

  step4 = runCommand "${pname}-step4-${version}"
    {
      buildInputs = [
        gcc
      ];
    } ''
    ${prepareStep { prev = step3; }}

    cd $_src/scripts
    ./Install_step_4
  '';

  step5 = runCommand "${pname}-step5-${version}"
    { } ''
    ${prepareStep { prev = step4; }}

    cd $_src/scripts
    # ./Install_step_5

    echo TIGCC script: Installing TIGCC documentation...

    mkdir $TIGCC/doc
    cd ..; cp AUTHORS BUGS CHANGELOG COPYING DIRECTORIES HOWTO INSTALL README README.linux README.osX $TIGCC/doc

    mkdir $TIGCC/doc/a68k
    cd sources/a68k; cp Bugs.txt Doc.txt History.txt ToDo.txt $TIGCC/doc/a68k

    mkdir $TIGCC/doc/tigcc
    cd ../tigcc; cp AUTHORS  COPYING  ChangeLog  README $TIGCC/doc/tigcc

    mkdir $TIGCC/doc/tprbuilder
    cd ../tprbuilder; cp AUTHORS  COPYING  ChangeLog  README $TIGCC/doc/tprbuilder

    rm -Rf $TIGCC/doc/parser

    mkdir $TIGCC/doc/patcher
    cd ../patcher; cp AUTHORS  COPYING  ChangeLog  README $TIGCC/doc/patcher

    rm -Rf $TIGCC/doc/html
    cd ../../tigcclib/doc; cp -Rf html $TIGCC/doc
    rm -Rf $TIGCC/doc/tigcclib
    pushd $TIGCC/doc >/dev/null
    ln -sf html tigcclib
    popd >/dev/null
    cp ../../tigcclib/doc/converter/tigccdoc $TIGCC/bin


    echo TIGCC script: Creating TIGCC projects folder...
    mkdir $TIGCC/projects

    echo Done.
  '';

  pkg = runCommand "${pname}-${version}"
    {
      passthru.skipUpdate = true;
    } ''
    mkdir -p $out
    cp -r ${step5}/out/* $out
  '';
in
pkg
