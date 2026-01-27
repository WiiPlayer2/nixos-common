{ lib, inputs, ... }:
with lib;
let
  flake-inputs = inputs;
in
{
  flake.overlays.legacy = final: prev: {
    unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
    nix-archipelago =
      if prev.stdenv.hostPlatform.system == "x86_64-linux" then
        flake-inputs.nix-archipelago.packages.${prev.stdenv.hostPlatform.system}
      else
        { archipelago-appimage = null; };
    nixgl = flake-inputs.nixgl.packages.${prev.stdenv.hostPlatform.system};
    retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs {
      src = prev.fetchFromGitHub {
        owner = "WiiPlayer2";
        repo = "retroarch-joypad-autoconfig";
        rev = "8fe0a7f9587abfa7322d5159fab8806844fb3b69";
        hash = "sha256-vHiYY8XlUcT/9DFKuSiM/thiEP0ksNNvNALoTYpA0q4=";
      };
    };
    wezterm-unstable = flake-inputs.wezterm.packages.${prev.stdenv.hostPlatform.system}.default;
    pidginPackages = prev.pidginPackages.overrideScope (
      final': prev': {
        # purple-slack = prev'.purple-slack.overrideAttrs {
        #   version = "2024-06-25";
        #   src = prev.fetchFromGitHub {
        #     owner = "dylex";
        #     repo = "slack-libpurple";
        #     rev = "ee43d55851531c074434b68339df0067bb6b70ca";
        #     sha256 = "sha256-KhpWPINn9Mwr2WBe9QxVcuPdYm9vYX2ZFdPS5cCoZJQ=";
        #   };
        # };

        # TODO: needs 2FA support
        tdlib-purple = prev'.tdlib-purple.overrideAttrs (prevAttrs: {
          version = "master-2024-09-07";
          src = final.fetchFromGitHub {
            owner = "BenWiederhake";
            repo = "tdlib-purple";
            rev = "43e6cc2f14ccd08171b1515f6216f4bbf84eed80";
            hash = "sha256-Uq8yfz6UM+U296nFnZtRuUGHdcNoTCHev6GcWTy+Ys0=";
          };

          buildInputs = prevAttrs.buildInputs ++ [
            final.openssl
          ];

          patches = [ ];

          cmakeFlags = prevAttrs.cmakeFlags ++ [
            "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
          ];

          meta = recursiveUpdate prevAttrs.meta {
            broken = false;
          };
        });

        libpurple-feed =
          let
            pname = "libpurple-feed";
            version = "master";
            src = final.fetchFromGitHub {
              owner = "moraxy";
              repo = pname;
              rev = "e9ba477b7fcdd43519479444340c7a6e6ef16603";
              hash = "sha256-k+fqEXDxttaLwYOi04ZPoIqer3MouUAS0LOqYKePfRM=";
            };
          in
          final.stdenv.mkDerivation {
            inherit pname version src;

            buildInputs = with final; [
              pkg-config
              pidgin
              libmrss
            ];

            postPatch = ''
              sed -i -e 's|PLUGIN_DIR_PURPLE:=$(shell pkg-config --variable=plugindir purple)|PLUGIN_DIR_PURPLE:=$(out)/lib/purple-2|' Makefile
              sed -i -e 's|DATA_ROOT_DIR_PURPLE:=$(shell pkg-config --variable=datarootdir purple)|DATA_ROOT_DIR_PURPLE:=$(out)/share|' Makefile
              sed -i -e 's|install --mode=0644|install -D --mode=0644|' Makefile
            '';
          };

        purple-presage =
          let
            pname = "purple-presage";
            version = "nightly-20260114-c927689";
            src = final.fetchFromGitHub {
              owner = "hoehermann";
              repo = pname;
              rev = version;
              fetchSubmodules = true;
              hash = "sha256-PJC0bGdUT+SiiEcbHZcTBSb9USPOLe0iMQUnSBOc4zQ=";
            };
            corrosionSrc = final.fetchFromGitHub {
              owner = "corrosion-rs";
              repo = "corrosion";
              rev = "v0.6.1";
              hash = "sha256-ppuDNObfKhneD9AlnPAvyCRHKW3BidXKglD1j/LE9CM=";
            };
            cargoRoot = "src/rust";
          in
          final.stdenv.mkDerivation {
            inherit
              pname
              version
              src
              cargoRoot
              ;

            nativeBuildInputs = with final; [
              pkg-config
              cmake
              git
              rustc
              cargo
              protobuf
              rustPlatform.cargoSetupHook
            ];

            buildInputs = with final; [
              pidgin
              glib
              openssl
              qrencode
            ];

            cmakeFlags = [
              "-DFETCHCONTENT_SOURCE_DIR_CORROSION=${corrosionSrc}"
            ];

            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit
                pname
                version
                src
                cargoRoot
                ;
              hash = "sha256-kogZM4IsZXly6OsNGKA0mHOJz2VXDXoTNp1hnlnRcIw=";
            };
            CARGO_NET_OFFLINE = "true";

            postPatch = ''
              sed -i -e "8i set(PURPLE_PLUGIN_DIR \"$out/lib/purple-2\")" CMakeLists.txt
              sed -i -e "8i set(PURPLE_DATA_DIR \"$out/share\")" CMakeLists.txt
            '';

            passthru = {
              inherit rustLib;
            };
          };

        purple-teams =
          let
            pname = "purple-teams";
            version = "daily-2026-01-13";
            src = final.fetchFromGitHub {
              owner = "EionRobb";
              repo = pname;
              rev = version;
              hash = "sha256-TKLwYHpihd19pQScc8RvkxOudN5GbxpB916vvgMYpqQ=";
            };
          in
          final.stdenv.mkDerivation {
            inherit pname version src;

            nativeBuildInputs = with final; [
              pkg-config
            ];

            buildInputs = with final; [
              pidgin
              json-glib
            ];

            postPatch = ''
              sed -i -e 's|`$(PKG_CONFIG) --variable=plugindir purple`|$(out)/lib/purple-2|' Makefile
              sed -i -e 's|`$(PKG_CONFIG) --variable=datadir purple`|$(out)/share|' Makefile
            '';
          };
      }
    );
  };
}
