# TODO: this should be moved and referenced correctly
{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kmod,
  gnused,
}:

stdenv.mkDerivation rec {
  pname = "hid-spsdm";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "LuciCodesStuff";
    repo = "Simple-PS3-DDR-Dancemat-Driver-for-Linux";
    rev = "8f2bd068a0ef2bac07a02f2f5837d858d22c9637";
    hash = "sha256-6DZ2/3Da+mk8qPXF1eKHzNzQXCxOQWcrmiJDcKquP8A=";
  };

  # sourceRoot = ".";
  # hardeningDisable = [ "pic" "format" ];                                             # 1
  nativeBuildInputs = kernel.moduleBuildDependencies; # 2
  buildInputs = [
    gnused
  ];

  makeFlags = [
    # "KERNELRELEASE=${kernel.modDirVersion}"                                 # 3
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "INSTALL_MOD_PATH=$(out)" # 5
  ];

  # needed for kernel >= 6.12
  patchPhase = ''
    sed -i 's/asm\/unaligned.h/linux\/unaligned.h/' hid-spsdm.c
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    cp hid-spsdm.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/aramg/droidcam";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.linux;
  };
}
