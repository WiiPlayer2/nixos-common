{
  inputs = {
    nixpkgs.follows = "nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-archipelago = {
      url = "github:WiiPlayer2/nix-archipelago";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    sops-nix.url = "github:Mic92/sops-nix";
    lanzaboote = {
      # url = "github:nix-community/lanzaboote/v1.0.0";
      url = "github:nix-community/lanzaboote/0403b4b7e8b2612657f0053a4c315e6c43eee9e6"; # Until a patch is released
      # inputs.nixpkgs.follows = "nixpkgs"; # I should probably never follow due to stability etc.
    };
    NixVirt = {
      url = "github:AshleyYakeley/NixVirt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      # url = "github:WiiPlayer2/nix-on-droid/?ref=feature/environment-extra-setup";
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      # url = "github:nix-community/stylix/pull/2338/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    k8s-bridge = {
      url = "github:WiiPlayer2/K8sBridge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    switchroot-nix = {
      url = "github:WiiPlayer2/switchroot-nixos";
      # url = "git+file:///home/admin/source/switchroot-nixos";
      # inputs.nixpkgs.follows = "nixpkgs"; # NOTE: kernel does not compile currently using 24.11
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    k8s-toolbox = {
      url = "github:WiiPlayer2/DarkLink.Kubernetes.Toolbox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comin = {
      url = "github:nlewo/comin";
      # url = "github:nlewo/comin/expose-username";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nueschtos = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ninelore-monoflake = {
      url = "github:ninelore/flake";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openspec = {
      url = "github:Fission-AI/OpenSpec/v1.3.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitor.url = "github:antonjah/nix-monitor";
    erosanix = {
      url = "github:emmanuelrosa/erosanix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.url = "github:NixOS/flake-compat";
      };
    };
    dms-plugin-calendar = {
      url = "github:alcxyz/DankCalendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-wallpaperengine = {
      url = "github:WiiPlayer2/dms-wallpaperengine?ref=feature/all-monitors";
      flake = false;
    };
    swayfx-enhanced = {
      url = "github:CreitinGameplays/swayfx-enhanced";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.scenefx.url = "github:CreitinGameplays/scenefx-enhanced";
    };
    bizhawk = {
      url = "github:TASEmulators/BizHawk/2.11";
      flake = false;
    };
    import-tree.url = "github:vic/import-tree";
    inhibridge.url = "git+https://codeberg.org/Scrumplex/inhibridge";
    flake-aspects.url = "git+https://tangled.org/oeiuwq.com/flake-aspects";
    agenix-shell.url = "github:aciceri/agenix-shell";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./flake
      ];
    };
}
