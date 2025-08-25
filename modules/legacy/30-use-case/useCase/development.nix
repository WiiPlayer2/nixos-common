{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.development;
in
{
  options.my.useCase.development =
    let
      self = config.my.useCase.development;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Sofware development and similar use cases";
      options = {
        common = mkSub "Common development tools";
        dotnet = mkSub ".NET";
        games = mkSub "Game Dev";
        android = mkSubGroup {
          description = "Android development use cases";
          options =
            let
              self = config.my.useCase.development.android;
              mkSub = mkSubUseCaseOption self;
            in
            {
              app = mkSub "Android app development";
              postmarketOS = mkSub "postmarketOS";
              lineageOS = mkSub "LineageOS";
            };
        };
        kubernetes = mkSub "Kubernetes";
        web = mkSub "Web";
        reverseEngineering = mkSub "Reverse engineering";
      };
    };

  config = mkMerge [
    (mkIf cfg.common.enable {
      my.programs = {
        git.enable = true;
        # git-repo.enable = true;
        tsrc.enable = true;
        mob.enable = true;
        wakatime-cli.enable = true;
      };
    })
    (mkIf cfg.dotnet.enable {
      my.useCase.development.common.enable = true;
      my.programs.rider.enable = true;
      my.programs.dotnet-sdk.enable = true;
    })
    (mkIf cfg.games.enable {
      my.useCase.development.common.enable = true;
      my.programs.rider.enable = true;
      my.programs.godot.enable = true;
      my.programs.aseprite.enable = true;
    })
    (mkIf cfg.android.app.enable {
      my.useCase.development.common.enable = true;
      my.programs.android-studio.enable = true;
    })
    (mkIf cfg.android.postmarketOS.enable {
      my.useCase.development.common.enable = true;
      my.programs.pmbootstrap.enable = true;
      my.programs.heimdall.enable = true;
      my.programs.android-tools.enable = true;
    })
    (mkIf cfg.android.lineageOS.enable {
      my.useCase.development.common.enable = true;
      my.programs.heimdall.enable = true;
      my.programs.android-tools.enable = true;
      my.programs.distrobox = {
        enable = true;
        manifests.lineageos-build.config = {
          image = "quay.io/toolbx/ubuntu-toolbox:24.04";
          additional_packages = [
            "bc"
            "bison"
            "build-essential"
            "ccache"
            "curl"
            "flex"
            "g++-multilib"
            "gcc-multilib"
            "git"
            "git-lfs"
            "gnupg"
            "gperf"
            "imagemagick"
            "lib32readline-dev"
            "lib32z1-dev"
            "libelf-dev"
            "liblz4-tool"
            "libsdl1.2-dev"
            "libssl-dev"
            "libxml2"
            "libxml2-utils"
            "lzop"
            "pngcrush"
            "rsync"
            "schedtool"
            "squashfs-tools"
            "xsltproc"
            "zip"
            "zlib1g-dev"
          ];
          init_hooks = [
            "wget https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb && rm -f libtinfo5_6.3-2_amd64.deb"
            "wget https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb && rm -f libncurses5_6.3-2_amd64.deb"
            "curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo"
            "chmod a+x /usr/bin/repo"
          ];
          additional_flags = [
            "-e ALLOW_NINJA_ENV=true"
            "-e USE_CCACHE=1"
            "-e CCACHE_EXEC=/usr/bin/ccache"
          ];
          volume = [
            "/nix:/nix"
            "/etc/static/profiles/per-user/admin:/etc/profiles/per-user/admin"
          ];
        };
      };
    })
    (mkIf cfg.kubernetes.enable {
      my.useCase.development.common.enable = true;
      my.programs = {
        k8s-bridge.enable = true;
      };
    })
    (mkIf cfg.web.enable {
      my.useCase.development.common.enable = true;
      my.programs = {
        nodejs.enable = true;
      };
    })
    (mkIf cfg.reverseEngineering.enable {
      my.useCase.development.common.enable = true;
      my.programs = {
        wireshark.enable = true;
      };
    })
  ];
}
