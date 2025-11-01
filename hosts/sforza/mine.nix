{ inputs', pkgs, ... }:
{
  vars = {
    email = "lewdovico@gnuweeb.org";
    isALaptop = true;
    opacity = 0.99;
    stateVersion = "24.11";
    terminal = "wezterm";
    timezone = "Asia/Tokyo";
    name = "Ludovico Piero";
    username = "lain";
    withGui = true;
  };

  mine = {
    gnome.enable = true;

    fish.enable = true;
    ghostty.enable = true;
    git.enable = true;
    gpg.enable = true;
    secrets.enable = true;
    tlp.enable = true;
    wezterm.enable = true;
    zen-browser.enable = true;

    fonts = {
      enable = true;
      size = 15;
      cjk = {
        name = "Noto Sans CJK";
        package = pkgs.noto-fonts-cjk-sans;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      icon = {
        name = "Symbols Nerd Font Mono";
        package = pkgs.nerd-fonts.symbols-only;
      };
      main = {
        name = "SF Pro Display";
        package = inputs'.ludovico-pkgs.packages.san-francisco-pro;
      };
      terminal = {
        name = "Iosevka Q";
        package = inputs'.ludovico-pkgs.packages.iosevka-q;
      };
    };
  };
}
