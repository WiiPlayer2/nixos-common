{ templates
, cfg
, pkgs
, NixVirt
, _lib
, ...
}:
let
  inherit (pkgs.lib)
    optionals
    lists
    ;
  presetCfg = cfg.domains.presets.windows;
  installIso = pkgs.requireFile {
    name = "Win11_24H2_English_x64.iso";
    url = "https://www.microsoft.com/en-us/software-download/windows11/";
    sha256 = "048b36zr2ys9q8ddd6cm179r5pqbfxy7xn0477mylb4ay4dr2sxm";
  };
  base = templates.domain.windows {
    name = "windows";
    uuid = "e96451ef-e3dc-559e-ba84-44f3f89f98c0";
    memory = {
      count = presetCfg.config.memory;
      unit = "GiB";
    };
    storage_vol = "/var/lib/libvirt/images/windows.qcow2";
    install_vol = if presetCfg.installMode then "${installIso}" else null;
    nvram_path = "/var/lib/libvirt/qemu/nvram/windows_VARS.fd";
    virtio_drive = false;
    virtio_video = false;
    virtio_net = true;
    install_virtio = presetCfg.installMode;
  };
  mergedDefinition = base // {
    vcpu.count = presetCfg.config.cpus;
    # cpu = base.cpu // {
    #   topology = {
    #     sockets = 1;
    #     cores = presetCfg.config.cpus;
    #     threads = 1;
    #   };
    # };

    devices = base.devices // {
      disk =
        base.devices.disk
          ++ optionals presetCfg.installMode [
          {
            type = "file";
            device = "cdrom";
            driver = {
              name = "qemu";
              type = "raw";
            };
            source = {
              file = "${_lib.mkAutoUnattendImage ./autounattend.xml}/autounattend.iso";
            };
            target = {
              bus = "sata";
              dev = "hde";
            };
            readonly = true;
          }
        ];

      channel = base.devices.channel ++ [
        {
          type = "unix";
          target = {
            type = "virtio";
            name = "org.qemu.guest_agent.0";
          };
        }
      ];

      video =
        let
          displayCount = 1;
          ram = 131072; # needed for 3440x1440
          vgamem = 32768;
          mkDisplay = isPrimary: {
            model = {
              type = "qxl";
              ram = ram;
              vram = ram;
              vgamem = vgamem;
              heads = 1;
              primary = isPrimary;
            };
          };
        in
        [
          (mkDisplay true)
        ] ++ (lists.genList (_: mkDisplay false) (displayCount - 1));
    };
  };
in
NixVirt.lib.domain.writeXML mergedDefinition
