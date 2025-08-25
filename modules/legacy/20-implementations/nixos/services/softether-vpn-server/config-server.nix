cfg: with (import ./_config.nix); {
  values = {
    ConfigRevision = {
      type = "uint";
      data = 1;
    };
    IPsecMessageDisplayed = {
      type = "bool";
      data = true;
    };
    Region = {
      type = "string";
      data = "$";
    };
  };
  sections = {
    DDnsClient.values.Disabled = {
      type = "bool";
      data = true;
    };
    IPsec.values = {
      EtherIP_IPsec = boolValue false;
      IPsec_Secret = stringValue "vpn";
      L2TP_DefaultHub = stringValue "$";
      L2TP_IPsec = boolValue false;
      L2TP_Raw = boolValue false;
    };
    ListenerList.sections = {
      Listener0.values = {
        DisableDos = boolValue false;
        Enabled = boolValue true;
        Port = uintValue 443;
      };
      Listener1.values = {
        DisableDos = boolValue false;
        Enabled = boolValue true;
        Port = uintValue 992;
      };
      Listener2.values = {
        DisableDos = boolValue false;
        Enabled = boolValue true;
        Port = uintValue 1194;
      };
      Listener3.values = {
        DisableDos = boolValue false;
        Enabled = boolValue true;
        Port = uintValue 5555;
      };
    };
    LocalBridgeList.values = {
      DoNotDisableOffloading = boolValue false;
    };
    ServerConfiguration = {
      values = {
        HashedPassword = byteValue "cfLL4NtkwV6eOFUlrV74VMSUiY8=";
      };
      sections = {
        GlobalParams.values = { };
        ServerTraffic.sections = {
          RecvTraffic.values = {
            BroadcastBytes = uint64Value 0;
            BroadcastCount = uint64Value 0;
            UnicastBytes = uint64Value 0;
            UnicastCount = uint64Value 0;
          };
          SendTraffic.values = {
            BroadcastBytes = uint64Value 0;
            BroadcastCount = uint64Value 0;
            UnicastBytes = uint64Value 0;
            UnicastCount = uint64Value 0;
          };
        };
        SyslogSettings.values = {
          HostName = stringValue "$";
          Port = uintValue 0;
          SaveType = uintValue 0;
        };
      };
    };
    VirtualHUB = { };
    VirtualLayer3SwitchList = { };
  };
}
