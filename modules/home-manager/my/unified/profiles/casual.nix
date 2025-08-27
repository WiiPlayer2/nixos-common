{ lib, config, pkgs, ... }:
with lib;
{
  options.unified.profiles.casual.enable = mkEnableOption "";

  config = mkIf config.unified.profiles.casual.enable {
    programs = {
      keepassxc = {
        enable = true;
        # see https://github.com/keepassxreboot/keepassxc/blob/develop/src/core/Config.cpp for reference
        settings = {
          General = {
            DropToBackgroundOnCopy = true;
            HideWindowOnCopy = true;
            MinimizeOnCopy = false;
            GlobalAutoTypeKey = 65;
            GlobalAutoTypeModifiers = 201326592;
          };

          Browser = {
            Enabled = true;
            UpdateBinaryPath = false;
            SearchInAllDatabases = true;
          };

          GUI = {
            MinimizeOnStartup = true;
            MinimizeToTray = true;
            ShowExpiredEntriesOnDatabaseUnlock = false;
            MinimizeOnClose = true;
            ShowTrayIcon = true;
          };

          SSHAgent.Enabled = true;

          KeeShare = {
            Active = "<?xml version=\\\"1.0\\\"?><KeeShare><Active/></KeeShare>\\n";
            Own = "<?xml version=\\\"1.0\\\"?><KeeShare><PrivateKey>MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCaGVrrMCYJ+zDtg95NjlV63CR+axLgvIfW/x5wSOqsnNWKXXbYjNjEMT82Q7RteUPVmTo63Fly6YInkHm+TKo63/95fF0WOivkdcFNayvSKrgKkThpA8izMr4yZYmzWAk88NkCmH0AGYAmmcjYBuFIgUE4AGeCRWI6Xz5aJ3cTz96/2OtUWx2NNdRh3KkhjGb1LqAW6+4fK8C49Pxd60BEtmMRntAA9b1r2Lwp8aW5faqimrc5ftTZUcJt9AhdZLAWbNkBUY1qbJ8beTkdj9Cw1VX3zRILJoOqEA+lxAm9/4SCqknicYZ4NeIFmfU0a4lhR6BL7TlrGJVXdKWh1a/fAgMBAAECggEARtK9axdjfDXi/F6dhqaSmddgvGtorzpm8kSpkDCrDq88I44mR4ugOrdpln6Sh7fymdKFJTVNtRcmFxn7Ih+pI0r85zBltggBUUxfjb3iU4MHt++bbgRrsxRwvsfU/ETLZiNJkbxUwv11XQhT+xlaZBDn0R26dPB/n1VT2mqF+2fZJZDSZxO+ju8uJjWzsBiuMJeiolyIW01U6B6pMj4r52fh72xJiFQzG+TdaiQirSILbc8/5UVp53A17wH/LxPMWmUgPXoFLJ7zsWBXXOjCVWEfs48aUf69IvVcwF+YkQhFe/VecaO+yycVY3D3rjovuAoOclFNFIkewdUdiaOd4QKBgQDHJCrB/SHvnxJpg0hNVuQ8Rg7+c733Q3o3ZJmmBWxHTafOziozlrSEuPwhegSiIzHzxtbnZcgzIZhCnHU9xEV5TOyLYvHgQmAp4kUNn034RSOdVUrgojLheToD7VYtKwwB1sapYN3KMA5X54nOY9gCk45D/aXVtH/RnWoZXyr4IQKBgQDGGOqNg1mU2YaZHVA3lja3kH1c4zCXyrXj+Ddok8iCs838k2Wk8FLG76gdZojsv1p+beYGCfg6HR54h0bSlAfzymKhoMkJDpnbOUetgetY1oz7lwPblZJsQv6hxHg0pVYa7ryQxRN6nARdgURU1hON/fRkUCac/IoGQ1jGjMun/wKBgFch0P+OBUI2JLU79u+3/CcPNFJLTCwbPydrgfrtVoIgTTMka7ykzRlhYxg2rj5PDfUu5CrdEuqkYV2L3ZSIAyne6YTXZyOLh03sLfCW6mOdxMZ7YkbFUWPsSeEcAF/E/Pz0/3lu47wqqKv3qAlBEGuYKmA/ZEcMMf0CVkEBrehhAoGAM3Cg56JmDqr1sqjT/bs59izFAOvV4HS5CruX18YYWShLovy7djsZo6Lz6r6Ha8K8wvvSsVrBZIXPNcka8O+TqRCyz/mqenmaJj0XicykymrcLTCnxctvPEGhUWxtMm6Ej3XS7VzflAUTdRxuHAGDDmoVnj7Z6AYD6WBvmw9Qiw0CgYEAk4w7JYeiovtvDbCchoFAlAB7g4CQrxWw6VAmhcY2iMBm3x904YjHrFKMPzwpdlBwYCsIJRJR7DHxu2ulgnurdl68/6vURurCPK0a1U+0fG2aJtbJ6aNeFji43VYvh58rMP5Kc1/b+hY8DLQgvO4NI60EdWrONbcbXBntxfTe93s=</PrivateKey><PublicKey><Signer>admin</Signer><Key>MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCaGVrrMCYJ+zDtg95NjlV63CR+axLgvIfW/x5wSOqsnNWKXXbYjNjEMT82Q7RteUPVmTo63Fly6YInkHm+TKo63/95fF0WOivkdcFNayvSKrgKkThpA8izMr4yZYmzWAk88NkCmH0AGYAmmcjYBuFIgUE4AGeCRWI6Xz5aJ3cTz96/2OtUWx2NNdRh3KkhjGb1LqAW6+4fK8C49Pxd60BEtmMRntAA9b1r2Lwp8aW5faqimrc5ftTZUcJt9AhdZLAWbNkBUY1qbJ8beTkdj9Cw1VX3zRILJoOqEA+lxAm9/4SCqknicYZ4NeIFmfU0a4lhR6BL7TlrGJVXdKWh1a/fAgMBAAECggEARtK9axdjfDXi/F6dhqaSmddgvGtorzpm8kSpkDCrDq88I44mR4ugOrdpln6Sh7fymdKFJTVNtRcmFxn7Ih+pI0r85zBltggBUUxfjb3iU4MHt++bbgRrsxRwvsfU/ETLZiNJkbxUwv11XQhT+xlaZBDn0R26dPB/n1VT2mqF+2fZJZDSZxO+ju8uJjWzsBiuMJeiolyIW01U6B6pMj4r52fh72xJiFQzG+TdaiQirSILbc8/5UVp53A17wH/LxPMWmUgPXoFLJ7zsWBXXOjCVWEfs48aUf69IvVcwF+YkQhFe/VecaO+yycVY3D3rjovuAoOclFNFIkewdUdiaOd4QKBgQDHJCrB/SHvnxJpg0hNVuQ8Rg7+c733Q3o3ZJmmBWxHTafOziozlrSEuPwhegSiIzHzxtbnZcgzIZhCnHU9xEV5TOyLYvHgQmAp4kUNn034RSOdVUrgojLheToD7VYtKwwB1sapYN3KMA5X54nOY9gCk45D/aXVtH/RnWoZXyr4IQKBgQDGGOqNg1mU2YaZHVA3lja3kH1c4zCXyrXj+Ddok8iCs838k2Wk8FLG76gdZojsv1p+beYGCfg6HR54h0bSlAfzymKhoMkJDpnbOUetgetY1oz7lwPblZJsQv6hxHg0pVYa7ryQxRN6nARdgURU1hON/fRkUCac/IoGQ1jGjMun/wKBgFch0P+OBUI2JLU79u+3/CcPNFJLTCwbPydrgfrtVoIgTTMka7ykzRlhYxg2rj5PDfUu5CrdEuqkYV2L3ZSIAyne6YTXZyOLh03sLfCW6mOdxMZ7YkbFUWPsSeEcAF/E/Pz0/3lu47wqqKv3qAlBEGuYKmA/ZEcMMf0CVkEBrehhAoGAM3Cg56JmDqr1sqjT/bs59izFAOvV4HS5CruX18YYWShLovy7djsZo6Lz6r6Ha8K8wvvSsVrBZIXPNcka8O+TqRCyz/mqenmaJj0XicykymrcLTCnxctvPEGhUWxtMm6Ej3XS7VzflAUTdRxuHAGDDmoVnj7Z6AYD6WBvmw9Qiw0CgYEAk4w7JYeiovtvDbCchoFAlAB7g4CQrxWw6VAmhcY2iMBm3x904YjHrFKMPzwpdlBwYCsIJRJR7DHxu2ulgnurdl68/6vURurCPK0a1U+0fG2aJtbJ6aNeFji43VYvh58rMP5Kc1/b+hY8DLQgvO4NI60EdWrONbcbXBntxfTe93s=</Key></PublicKey></KeeShare>\\n";
            QuietSuccess = true;
          };

          Security.IconDownloadFallback = true;
        };
      };
    };

    services.ssh-agent.enable = true;

    home.packages = with pkgs; [
      maestral
      maestral-gui
      whatsie
    ];

    my.startup = {
      # Wait 5 seconds for system theme to be correctly set
      keepassxc.command = "sleep 5 && keepassxc-startup && keepassxc-watch";
      maestral.command = "${pkgs.maestral-gui}/bin/maestral_qt";
      whatsie.command = "${lib.getExe pkgs.whatsie}";
    };
  };
}
