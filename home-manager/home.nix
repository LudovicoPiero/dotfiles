# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nix-colors,
  ...
}: let
  nix-colors-lib = nix-colors.lib-contrib {inherit pkgs;};
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.i3

    # Apps
    outputs.homeManagerModules.git
    outputs.homeManagerModules.kitty
    outputs.homeManagerModules.foot
    outputs.homeManagerModules.wezterm
    outputs.homeManagerModules.dunst
    outputs.homeManagerModules.wofi
    outputs.homeManagerModules.lf
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.gtk
    outputs.homeManagerModules.fish
    outputs.homeManagerModules.zsh
    outputs.homeManagerModules.starship
    outputs.homeManagerModules.direnv
    outputs.homeManagerModules.vscode
    outputs.homeManagerModules.spicetify
    outputs.homeManagerModules.obs
    outputs.homeManagerModules.gpg

    # Browser
    outputs.homeManagerModules.chromium
    outputs.homeManagerModules.firefox

    # Scripts
    outputs.homeManagerModules.scripts

    # Development
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.helix

    # Or modules exported from other flakes (such as nix-colors):
    inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModule
    inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./chromium.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # Or overlays exported from other flakes:
      inputs.nur.overlay
      inputs.hyprpicker.overlays.default
      inputs.nixpkgs-wayland.overlay

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Set nix-colors Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./wall.jpg;
  #   kind = "dark";
  # };

  home = {
    username = "ludovico";
    homeDirectory = "/home/ludovico";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    discord-canary
    inputs.webcord.packages.${pkgs.system}.default
  ];

  # Enable home-manager and git
  programs.git.enable = true;
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
