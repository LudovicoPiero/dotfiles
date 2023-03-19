{
  pkgs,
  config,
  lib,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    services.picom = {
      enable = true;
      backend = "glx";
      fade = false;
      inactiveOpacity = 0.88;
      opacityRules = [
        "95:class_g = 'URxvt' && !_NET_WM_STATE@:32a"
      ];
      settings = {
        blur = {
          method = "dual_kawase";
          strength = 15;
        };
      };
      shadow = false;
      wintypes = {
        popup_menu = {opacity = config.services.picom.menuOpacity;};
        dropdown_menu = {opacity = config.services.picom.menuOpacity;};
      };
      extraArgs = ["--legacy-backends"];
    };
  };

  services.xserver.windowManager.dwm.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: {
        src = ./.;
        buildInputs = old.buildInputs ++ [pkgs.pango pkgs.pkg-config];
      });
    })
  ];
}
