{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-flake = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "nvim-flake";
    };

    hjem = {
      type = "github";
      owner = "feel-co";
      repo = "hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    programsdb = {
      type = "github";
      owner = "wamserma";
      repo = "flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      type = "github";
      owner = "0xc000022070";
      repo = "zen-browser-flake";
    };

    firefox-addons = {
      type = "gitlab";
      owner = "rycee";
      repo = "nur-expressions";
      dir = "pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        systems = [
          "x86_64-linux"
          # "aarch64-linux"
        ];

        _module.args.extendedLib = nixpkgs.lib.extend (
          import ./lib/default.nix { inherit inputs withSystem; }
        );

        imports = [ ./system/default.nix ];

        # #TODO:
        # perSystem =
        #   {
        #     config,
        #     self',
        #     inputs',
        #     pkgs,
        #     system,
        #     ...
        #   }:
        #   {
        #     # packages.default = ...
        #   };
      }
    );
}
