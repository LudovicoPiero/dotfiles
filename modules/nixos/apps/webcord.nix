{ pkgs, inputs, ... }:
let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "9d3433d3ad3d715e14346cada44953ea82fbc80b";
    sha256 = "sha256-cWpog52Ft4hqGh8sMWhiLUQp/XXipOPnSTG6LwUAGGA=";
  };

  theme = "${catppuccin}/themes/mocha.theme.css";
in {
  environment.systemPackages = [
    (inputs.webcord.packages.${pkgs.system}.default.override {
      flags = [ "--add-css-theme=${theme}" ];
    })
  ];
}
