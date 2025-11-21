{ self', pkgs, ... }:
{
  vars = {
    email = "lewdovico@gnuweeb.org";
    isALaptop = true;
    opacity = 1.00;
    stateVersion = "24.11";
    terminal = "wezterm";
    timezone = "Asia/Tokyo";
    name = "Ludovico Piero";
    username = "lain";
    withGui = true;
  };

  mine = {
    hyprland.enable = true;
    keyring.enable = true;
    mako.enable = true;
    waybar.enable = true;
    greetd.enable = true;
    pipewire.enable = true;
    cliphist.enable = true;
    lockscreen.enable = true;
    xdg-portal.enable = true;

    fish.enable = true;
    inputMethod.enable = true;
    inputMethod.type = "fcitx5";
    ghostty.enable = true;
    git.enable = true;
    gpg.enable = true;
    music.enable = true;
    secrets.enable = true;
    tlp.enable = true;
    wezterm.enable = true;
    zen-browser.enable = true;

    theme = {
      gtk.enable = true;
      qt.enable = true;
    };

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
        package = self'.packages.san-francisco-pro;
      };
      terminal = {
        name = "Iosevka Q";
        package = self'.packages.iosevka-q;
      };
    };
  };
}
