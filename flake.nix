{
  description = "My NixOS Flake Configuration";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    fu.url = "github:numtide/flake-utils";

    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.05";
    master.url = "github:nixos/nixpkgs";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixos";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-utils.follows = "fu";
    };

    digga = {
      url = "github:divnix/digga";
      inputs.nixpkgs.follows = "nixos";
      inputs.nixlib.follows = "nixos";
      inputs.home-manager.follows = "home";
      inputs.flake-utils.follows = "fu";
      inputs.flake-compat.follows = "flake-compat";
    };

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixos";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixos";
    };

    nix-super = {
      url = "github:privatevoid-net/nix-super";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-compat.follows = "flake-compat";
    };

    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixos";
    };

    # swayfx.url = "github:WillPower3309/swayfx";

    impermanence.url = "github:nix-community/impermanence";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixos";
      inputs.nixpkgs-stable.follows = "stable";
      inputs.flake-utils.follows = "fu";
    };

    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # nixpkgs-wayland.inputs.nixpkgs.follows = "nixos";

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-utils.follows = "fu";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixos";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-utils.follows = "fu";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-utils.follows = "fu";
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-utils.follows = "fu";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  outputs = {
    self,
    digga,
    nixos,
    ragenix,
    aagl,
    home,
    hyprland,
    impermanence,
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
        master = {
          imports = [(digga.lib.importOverlays ./overlays)];
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
        (import ./pkgs)
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            ragenix.nixosModules.default
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            nur.nixosModules.nur
          ];
        };

        imports = [(digga.lib.importHosts ./hosts)];
        hosts = {
          sforza = {
            channelName = "master";
            modules = [
              # nixos-hardware.nixosModules.common-pc-laptop-ssd
              aagl.nixosModules.default
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

              hyprland = [windowManager.hyprland];
              sway = [windowManager.sway];
              cinnamon = [desktopEnvironment.cinnamon];
              kde = [desktopEnvironment.kde];
              gnome = [desktopEnvironment.gnome];
            };
        };
      };

      home.modules = [inputs.hyprland.homeManagerModules.default];

      devshell = ./shell;

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;
    };
}
