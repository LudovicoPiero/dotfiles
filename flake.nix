{
  description = "A very basic flake";

  inputs = {
    # Nixpkgs branches
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Default nixpkgs for packages and modules
    nixpkgs.follows = "master";

    # Flake inputs
    aagl.url = "github:ezKEa/aagl-gtk-on-nix"; # Anime Game Launcher
    emacs.url = "github:nix-community/emacs-overlay";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    home.url = "github:nix-community/home-manager";
    hyprland.url = "github:hyprwm/hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    impermanence.url = "github:nix-community/impermanence";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nil.url = "github:oxalica/nil?rev=18de045d7788df2343aec58df7b85c10d1f5d5dd";
    nix.url = "github:nixos/nix";
    nur.url = "github:nix-community/NUR";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nix-colors.url = "github:Misterio77/nix-colors";
    sops-nix.url = "github:Mic92/sops-nix";
    spicetify.url = "github:the-argus/spicetify-nix";
    statix.url = "github:nerdypepper/statix";
    swayfx.url = "github:WillPower3309/swayfx";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    # Minimize duplicate instances of inputs
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    emacs.inputs.nixpkgs.follows = "nixpkgs";
    home.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nix.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "stable";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";
    statix.inputs.nixpkgs.follows = "nixpkgs";
    swayfx.inputs.nixpkgs.follows = "nixpkgs";
    xdph.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    home,
    nixpkgs,
    ...
  } @ inputs: let
    config = {
      allowBroken = true;
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    filterNixFiles = k: v: v == "regular" && nixpkgs.lib.hasSuffix ".nix" k;

    importNixFiles = path:
      with nixpkgs.lib;
        (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
            (filterAttrs filterNixFiles (builtins.readDir path))))
        import;

    overlays = with inputs;
      [
        neovim-nightly-overlay.overlay
      ]
      # Overlays from ./overlays directory
      ++ (importNixFiles ./overlays);

    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      #"aarch64-linux"
      #"i686-linux"
      #"aarch64-darwin"
      #"x86_64-darwin"
    ];
  in {
    nixosConfigurations = {
      sforza = import ./hosts/sforza {
        inherit config nixpkgs overlays inputs;
      };
      nostra = import ./hosts/nostra {
        inherit config nixpkgs overlays inputs;
      };
    };

    homeConfigurations = {
      ludovico = import ./users/ludovico {
        inherit config nixpkgs home overlays inputs;
      };
    };

    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Default formatter for the entire repo
    formatter = nixpkgs.lib.genAttrs ["x86_64-linux"] (_system: pkgs.alejandra);
  };
}
