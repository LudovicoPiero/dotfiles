{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "screen-256color";
        initial-window-size-chars = "82x23";
        initial-window-mode = "windowed";
        pad = "10x10";
        resize-delay-ms = 100;
      };

      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };
    };
  };
}
