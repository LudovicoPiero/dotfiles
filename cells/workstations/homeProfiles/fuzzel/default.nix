{ lib, config, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "Iosevka q Semibold-16";
        terminal = "kitty";
        icon-theme = "${config.gtk.iconTheme.name}";
        prompt = "->";
      };

      border = {
        width = 2;
        radius = 0;
      };

      dmenu = {
        mode = "text";
      };
    };
  };
}
