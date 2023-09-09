{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = with pkgs; [
    webcord-vencord
  ];

  services.arrpc.enable = true;
}
