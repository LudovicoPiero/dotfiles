{
  pkgs,
  inputs,
  config,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  inherit (config.colorScheme) colors;
in {
  programs.spicetify = {
    enable = true;
    spotifyPackage = inputs.self.packages.${pkgs.system}.spotify;
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "custom";
    customColorScheme = {
      text = "${colors.base04}";
      subtext = "${colors.base0D}";
      extratext = "${colors.base01}";
      main = "${colors.base00}";
      sidebar = "${colors.base00}";
      player = "${colors.base00}";
      sec-player = "${colors.base01}";
      card = "${colors.base0E}";
      sec-card = "${colors.base02}";
      shadow = "000000";
      selected-row = "${colors.base0D}";
      button = "${colors.base03}";
      button-active = "${colors.base06}";
      button-disabled = "${colors.base04}";
      button-knob = "${colors.base0B}";
      tab-active = "${colors.base0B}";
      notification = "${colors.base0B}";
      notification-error = "${colors.base0E}";
      misc = "${colors.base0A}";
    };

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock
    ];

    # enabledCustomApps = ["marketplace"];
  };
}
