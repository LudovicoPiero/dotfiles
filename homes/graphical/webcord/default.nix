{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = [
    inputs.self.packages.${pkgs.system}.webcord-vencord
  ];

  services.arrpc.enable = true;
}
