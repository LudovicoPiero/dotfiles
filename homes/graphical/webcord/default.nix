{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = with pkgs; [
    webcord-vencord
    vesktop
  ];

  services.arrpc.enable = false;
}
