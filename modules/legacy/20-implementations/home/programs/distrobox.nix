{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.distrobox;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      distrobox
      distrobox-tui
      boxbuddy

      (
        let
          manifestsData = filter (x: x.value.enable) (attrsToList cfg.manifests);
          mapConfigValue =
            value:
            if isString value then
              [ value ]
            else if isList value then
              value
            else if isBool value then
              [ (boolToString value) ]
            else
              throw "Unrecognized value type (${toString value})";
          mapConfigItem = name: value: map (x: "${name}=${x}") (mapConfigValue value);
          mapManifestToContent =
            name: data:
            let
              items = filter (x: !(isNull x.value)) (attrsToList data.config);
              lines = concatMap (x: mapConfigItem x.name x.value) items;
              linesConcat = concatStringsSep "\n" lines;
            in
            ''
              [${name}]
              ${linesConcat}
            '';
          distroboxManifestsContent = concatStringsSep "\n" (
            map (x: mapManifestToContent x.name x.value) manifestsData
          );
          distroboxManifests = pkgs.writeScript "distrobox-manifests" distroboxManifestsContent;
        in
        pkgs.writeShellScriptBin "distrobox-apply-manifests" ''
          distrobox assemble create --file ${distroboxManifests} "$@"
        ''
      )
    ];

    # home.activation.distrobox =
    #   let
    #     manifestsData = filter (x: x.value.enable) (attrsToList cfg.manifests);
    #     mapManifestToContent =
    #       name: data:
    #       ''
    #       [${name}]
    #       image=${data.image}
    #       '';
    #     distroboxManifestsContent =
    #       concatStringsSep
    #       "\n"
    #       (map (x: mapManifestToContent x.name x.value) manifestsData);
    #     distroboxManifests = pkgs.writeScript "distrobox-manifests" distroboxManifestsContent;
    #   in
    #   lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     echo "Distrobox containers will NOT be replaced."
    #     run ${pkgs.distrobox}/bin/distrobox assemble $VERBOSE_ARG \
    #       create --file ${distroboxManifests}
    #   '';
  };
}
