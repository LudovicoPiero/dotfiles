{ inputs, cell }:
{
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    tray = true;
    settings = {
      general = {
        brightness-day = "0.8";
        brightness-night = "0.8";
      };
    };
  };
}
