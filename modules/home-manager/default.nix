# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  hyprland = import ./hyprland;
  fish = import ./fish.nix;
  gtk = import ./gtk.nix;

  # Apps
  foot = import ./apps/foot.nix;
  kitty = import ./apps/kitty.nix;
  mako = import ./apps/mako.nix;
  waybar = import ./apps/waybar.nix;
  wofi = import ./apps/wofi.nix;
  spicetify = import ./apps/spicetify;

  # Development
  git = import ./development/git.nix;
  gpg = import ./development/gpg.nix;
  direnv = import ./development/direnv.nix;
  vscode = import ./development/vscode.nix;
  emacs = import ./development/emacs/emacs.nix;

  # Browser
  chromium = import ./browser/chromium.nix;
  firefox = import ./browser/firefox.nix;
}
