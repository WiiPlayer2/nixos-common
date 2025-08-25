{ NixVirt
, ...
}:
NixVirt.lib.network.writeXML (
  NixVirt.lib.network.templates.bridge
    {
      uuid = "80159afb-6d93-504f-9876-ca7635f5e34d";
      subnet_byte = 69;
    } // {
    mac = {
      address = "52:54:00:58:dd:2a";
    };
  }
)
