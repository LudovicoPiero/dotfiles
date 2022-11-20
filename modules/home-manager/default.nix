# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  # List your module files here
  hyprland = import ./hyprland;
  fish = import ./fish.nix;
  gtk = import ./gtk.nix;

  # Development
  git = import ./development/git.nix;
  gpg = import ./development/gpg.nix;
  direnv = import ./development/direnv.nix;

  # Browser
  chromium = import ./browser/chromium.nix;
  firefox = import ./browser/firefox.nix;
}
