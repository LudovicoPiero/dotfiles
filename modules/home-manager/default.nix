# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  fish = import ./shell/fish.nix;
  zsh = import ./shell/zsh.nix;
  starship = import ./shell/starship.nix;
  gtk = import ./gtk.nix;

  # Wayland / Window Manager
  hyprland = import ./wayland/hyprland;
  i3 = import ./x11/i3;

  # Apps
  dunst = import ./apps/dunst;
  webcord = import ./apps/webcord;
  eww = import ./apps/eww;
  foot = import ./apps/foot;
  i3status = import ./apps/i3status;
  kitty = import ./apps/kitty;
  wezterm = import ./apps/wezterm;
  lf = import ./apps/lf;
  mako = import ./apps/mako;
  obs = import ./apps/obs;
  picom = import ./apps/picom;
  spicetify = import ./apps/spicetify;
  tmux = import ./apps/tmux;
  waybar = import ./apps/waybar;
  wofi = import ./apps/wofi;

  # Scripts
  scripts = import ./scripts;

  # Development
  git = import ./development/git.nix;
  gpg = import ./development/gpg.nix;
  direnv = import ./development/direnv.nix;
  vscode = import ./development/vscode.nix;
  neovim = import ./development/neovim;
  helix = import ./development/helix;

  # Browser
  chromium = import ./browser/chromium.nix;
  firefox = import ./browser/firefox.nix;
}
