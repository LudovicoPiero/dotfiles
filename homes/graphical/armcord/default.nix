{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = with pkgs; [
    armcord
  ];

  services.arrpc.enable = true;
}
