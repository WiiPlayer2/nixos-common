{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  restartCommand = "${getExe config.programs.dank-material-shell.package} restart";
in
{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile = {
    "DankMaterialShell/settings.json".onChange = restartCommand;
    "DankMaterialShell/plugin_settings.json".onChange = restartCommand;
  };

  home.file."${config.xdg.stateHome}/DankMaterialShell/session.json".mergeWith = ''
    ${getExe pkgs.jq} '
    def merge_val(f):
        def merge_arr(f):
            f as $f |
            $f.first as $a |
            $f.second as $b |
            ($a - $b) + $b;

        def merge_obj(f):
            f as $f |
            $f.first as $a |
            $f.second as $b |
            ($a | keys) as $keys_a |
            ($b | keys) as $keys_b |
            ($keys_a + $keys_b | unique) as $keys |
            ($keys | map(. as $key | {
                key: $key,
                value:
                    if $keys_a | contains([$key])
                    then
                        if $keys_b | contains([$key])
                        then merge_val({
                            first: $a[$key],
                            second: $b[$key]
                        })
                        else $a[$key]
                        end
                    else $b[$key]
                    end
            })) as $entries |
            $entries | from_entries;

        f as $f |
        $f.first as $a |
        $f.second as $b |
        ($a | type) as $type_a |
        ($b | type) as $type_b |
        if $type_a != $type_b
        then $b
        else
            if $type_a == "object"
            then merge_obj(f)
            else
                if $type_a == "array"
                then merge_arr(f)
                else $b
                end
            end
        end;

    merge_val({
        first: .[0],
        second: .[1],
    })
    ' "$HM_DEST_FILE" "$HM_SOURCE_FILE" | ${getExe' pkgs.moreutils "sponge"} "$HM_DEST_FILE"
  '';

  systemd.user.services.dms.Service.Environment = [
    # see https://github.com/AvengeMedia/DankMaterialShell/blob/335c5b4ac55382c2077ab2a18129c03dafb9558b/quickshell/Common/settings/Processes.qml#L78
    # TODO: should depend on fprint setting and/or service OR fix implementation to recognize correctly
    "DMS_FORCE_FPRINT_AVAILABLE=1"
    # "DMS_FORCE_U2F_AVAILABLE=1"
  ];
}
