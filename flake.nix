{
  description = "My NixOS Flake Configuration";

  nixConfig = {
    extra-substituters = [
      "https://nrdxp.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixos";

    hyprland.url = "github:hyprwm/hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";

    swayfx.url = "github:WillPower3309/swayfx";

    impermanence.url = "github:nix-community/impermanence";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixos";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixos";

    spicetify-nix.url = "github:the-argus/spicetify-nix";
    nix-gaming.url = "github:fufexan/nix-gaming";

    nil.url = "github:oxalica/nil";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
  };

  outputs = {
    self,
    digga,
    nixos,
    home,
    hyprland,
    impermanence,
    nixos-hardware,
    nur,
    ...
  } @ inputs:
    digga.lib.mkFlake
    {
      inherit self inputs;

      channelsConfig = {
        allowUnfree = true;
        allowBroken = true;
      };

      channels = {
        nixos = {
          imports = [(digga.lib.importOverlays ./overlays)];
          overlays = [];
        };
      };

      lib = import ./lib {lib = digga.lib // nixos.lib;};

      sharedOverlays = [
        (_final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (_lfinal: _lprev: {
            our = self.lib;
          });
        })
        nur.overlay
        (import ./pkgs)
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            nur.nixosModules.nur
          ];
        };

        imports = [(digga.lib.importHosts ./hosts)];
        hosts = {
          sforza = {
            modules = [
              nixos-hardware.nixosModules.common-cpu-amd
              nixos-hardware.nixosModules.common-cpu-amd-pstate
              nixos-hardware.nixosModules.common-gpu-amd
              nixos-hardware.nixosModules.common-pc-laptop-ssd
              hyprland.nixosModules.default
              impermanence.nixosModules.impermanence
            ];
          };
          duchy = {
            modules = [
              inputs.nixos-wsl.nixosModules.wsl
            ];
          };
        };
        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles;
          suites = with builtins; let
            explodeAttrs = set: map (a: getAttr a set) (attrNames set);
          in
            with profiles; rec {
              base = (explodeAttrs core) ++ (explodeAttrs editor) ++ (explodeAttrs virtualisation) ++ [security vars];
              desktop = base ++ (explodeAttrs graphical) ++ (explodeAttrs browser);

              hyprland = desktop ++ [windowManager.hyprland];
              sway = desktop ++ [windowManager.sway];
            };
        };
      };

      home.modules = [inputs.hyprland.homeManagerModules.default];

      devshell = ./shell;

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;
    };
}
