{
  pkgs,
  inputs,
  ...
} @ args: {
  home.packages = with pkgs; [
    # Utils
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = import ./settings.nix args;
    plugins = [inputs.hy3.packages.${pkgs.system}.hy3];
  };
}
