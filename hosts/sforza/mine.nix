{ pkgs, self', ... }:
{
  vars = {
    # -- Identity --
    name = "Ludovico Piero";
    username = "lain";
    email = "lewdovico@gnuweeb.org";

    # -- System --
    stateVersion = "24.11";
    timezone = "Asia/Tokyo";
    isALaptop = true;
    withGui = true;

    # -- Visuals --
    terminal = "wezterm";
    opacity = 1.00;
  };

  mine = {
    # -- Desktop Environment --
    hyprland.enable = true;
    greetd.enable = true;
    lockscreen.enable = true;
    waybar.enable = true;
    mako.enable = true;
    xdg-portal.enable = true;

    # -- System Services --
    pipewire.enable = true;
    cliphist.enable = true;
    keyring.enable = true;
    secrets.enable = true;
    tlp.enable = true;
    gpg.enable = true;

    # -- Input Method --
    inputMethod = {
      enable = true;
      type = "fcitx5";
    };

    # -- Applications --
    fish.enable = true;
    fuzzel.enable = true;
    git.enable = true;
    music.enable = true;
    zen-browser.enable = true;
    ghostty.enable = true;
    wezterm.enable = true;

    # -- Theming --
    theme = {
      gtk.enable = true;
      qt.enable = true;
    };

    # -- Typography --
    fonts = {
      enable = true;
      size = 15;

      main = {
        name = "Inter";
        package = pkgs.inter;
      };

      terminal = {
        name = "Iosevka Q SemiBold";
        package = self'.packages.iosevka-q;
      };

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
    };
  };
}
