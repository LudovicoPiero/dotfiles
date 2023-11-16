{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = with inputs.self.packages.${pkgs.system}; [
    webcord-vencord
    vesktop
  ];

  services.arrpc.enable = true;
}
