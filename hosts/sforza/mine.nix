{ inputs', pkgs, ... }:
{
  vars = {
    # List of available color schemes:
    # https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/
    #TODO: fix colorscheme
    colorScheme = "gruvbox-material-dark-hard";
    email = "lewdovico@gnuweeb.org";
    isALaptop = true;
    opacity = 0.88; # FIXME: still unused
    stateVersion = "24.11";
    terminal = "ghostty";
    timezone = "Asia/Tokyo";
    username = "lain";
    withGui = true;
  };

  mine = {
    fish.enable = true;
    ghostty.enable = true;
    git.enable = true;
    gpg.enable = true;
    secrets.enable = true;
    tlp.enable = true;

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
