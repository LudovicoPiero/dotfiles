{ ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        decorations = "None";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        startup_mode = "Maximized";
      };

      scrolling = {
        history = 1000;
        multiplier = 5;
      };

      mouse.hide_when_typing = true;
    };
  };
}
