# This file defines overlays
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    discord-canary = prev.discord-canary.override {
      withOpenASAR = true;
      nss = pkgs.nss_latest;
    };
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
