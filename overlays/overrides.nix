{ lib, inputs, ... }:
with lib;
let
  patchPinned =
    {
      pkg,
      version,
      overrideFn,

      extraInfo ? null,
      nixpkgsPR ? null,
    }:
    let
      nixpkgsPRInfo =
        if nixpkgsPR == null then
          null
        else
          ''
            Track the current state of the pull request at https://nixpk.gs/pr-tracker.html?pr=${toString nixpkgsPR}
          '';

      infoLines =
        let
          nonNullInfo = filter (x: x != null) [
            nixpkgsPRInfo
            extraInfo
          ];
          infoText = concatStrings (map (x: "\n\n${x}") nonNullInfo);
        in
        infoText;

      versionComparison = compareVersions pkg.version version;
      isOlderThanPinned = versionComparison == -1;
      isPinned = versionComparison == 0;
      isNewerThanPinned = versionComparison == 1;
    in
    if isOlderThanPinned then
      warn ''
        ${pkg.name} will be patched on version ${version} but nixpkgs currently ships ${pkgs.version}.
      '' pkg
    else if isPinned then
      warn ''
        ${pkg.name} is patched on version ${version}.${infoLines}
      '' (overrideFn pkg)
    else
      throw ''
        ${pkg.pname} was patched on version ${version} but nixpkgs now ships ${pkg.version}.${infoLines}
      '';

  pythonOverlay = pfinal: pprev: {
    cloup = pprev.cloup.overrideAttrs (
      finalAttrs: prevAttrs: {
        postPatch = prevAttrs.postPatch + ''
          exit 1
          substituteInPlace setup.py \
            --replace-fail "setuptools_scm<10" setuptools_scm
        '';
      }
    );
  };
in
{
  flake.overlays.overrides =
    final: prev:
    optionalAttrs (!prev ? __common_is_applied) {
      # TODO: this is just a "temporary" workaround while the overlay is imported via the legacy hosts flake module and the newer core nixos module
      __common_is_applied = true;

      poptracker = prev.unstable.poptracker.overrideAttrs (
        finalAttrs: prevAttrs: {
          installPhase =
            let
              elaboratedSystem = prev.lib.systems.elaborate prev.stdenv.hostPlatform.system;
              arch = elaboratedSystem.qemuArch;
              fixedInstallPhase = prev.lib.replaceStrings [ "x86_64" ] [ arch ] prevAttrs.installPhase;
            in
            fixedInstallPhase;

          meta = prevAttrs.meta // {
            platforms = prevAttrs.meta.platforms ++ [
              "aarch64-linux"
            ];
          };
        }
      );

      # jetbrains = prev.jetbrains // {
      #   rider = patchPinned {
      #     pkg = prev.jetbrains.rider;
      #     version = "2026.2.0.1";
      #     nixpkgsPR = 546636;
      #     /*
      #       /nix/store/wy1dwqdbrkhw3hj4ll7a9av7v7w6wqxf-rider-2026.2/rider/lib/ReSharperHost/linux-x64/Rider.Backend --runtimeconfig /nix/store/wy1dwqdbrkhw3hj4ll7a9av7v7w6wqxf-rider-2026.2/rider/lib/ReSharperHost/Rider.Backend.netcore.runtimeconfig.json --Port=38669 --enablecpp
      #       /nix/store/wy1dwqdbrkhw3hj4ll7a9av7v7w6wqxf-rider-2026.2/rider/lib/ReSharperHost/linux-x64/Rider.Backend: error while loading shared libraries: libstdc++.so.6: cannot open shared object file: No such file or directory
      #     */
      #     overrideFn =
      #       x:
      #       x.overrideAttrs (attrs: {
      #         appendRunpaths = (attrs.appendRunpaths or [ ]) ++ [ "${final.stdenv.cc.cc.lib}/lib" ];
      #       });
      #   };
      # };

      cyanrip = patchPinned {
        pkg = prev.cyanrip;
        version = "0.9.3.1";
        overrideFn =
          x:
          x.overrideAttrs (attrs: {
            patches = (attrs.patches or [ ]) ++ [
              (final.fetchpatch {
                url = "https://github.com/cyanreg/cyanrip/commit/7dbbe1122248e91510351900af84a6f7c0464271.patch";
                hash = "sha256-qiDXNQFINI4QvAQ4+De7OXHnScQT3gSiPtheq+1rTkg=";
              })
            ];
          });
        extraInfo = ''
          See https://github.com/cyanreg/cyanrip/issues/142
        '';
      };

      nodejs_latest = patchPinned {
        pkg = prev.nodejs_latest;
        version = "26.9.0";
        overrideFn =
          x:
          x.override {
            nodejs-slim = final.nodejs-slim_latest;
          };
        extraInfo = ''
          needed for llama-cpp
        '';
      };

      nodejs-slim_latest = patchPinned {
        pkg = prev.nodejs-slim_latest;
        version = "26.9.0";
        overrideFn =
          x:
          x.overrideAttrs (prev: {
            doCheck = false;
            # checkFlags = lib.map (
            #   flag:
            #   if lib.hasPrefix "CI_SKIP_TESTS=" flag then
            #     "${flag},"
            #     + lib.concatStringsSep "," [
            #       "test-tls-over-http-tunnel"
            #       "test-http-agent-keepalive"
            #       "test-https-proxy-request-invalid-char-in-url"
            #       "test-fs-cp-async-file-modes"
            #     ]
            #   else
            #     flag
            # ) (prev.checkFlags or [ ]);
          });
        extraInfo = ''
          needed for llama-cpp
        '';
      };
    };
}
