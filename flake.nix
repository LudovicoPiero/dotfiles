{
  description = "xd uwu";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-unstable";

    hjem.url = "github:feel-co/hjem";
    hjem-rum.url = "github:snugnug/hjem-rum";
    hjem.inputs.nixpkgs.follows = "nixpkgs";
    hjem-rum.inputs.nixpkgs.follows = "nixpkgs";
    hjem-rum.inputs.hjem.follows = "hjem";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:gerg-l/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    # Nix VS Code Extensions.
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Anime Games
    anime.url = "github:ezKEa/aagl-gtk-on-nix";
    anime.inputs.nixpkgs.follows = "nixpkgs";

    # Lix
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";

    minecraft.url = "github:hero-persson/FjordLauncherUnlocked";
    minecraft.inputs.nixpkgs.follows = "nixpkgs";

    ludovico-nixvim.url = "github:LudovicoPiero/nvim-flake";
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin-base16.url = "github:catppuccin/base16";
    catppuccin-base16.flake = false;
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
        ./parts
        ./packages
      ];
    };
}
