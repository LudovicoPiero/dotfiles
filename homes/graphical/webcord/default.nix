{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = with inputs.master.legacyPackages.${pkgs.system}; [
    webcord-vencord
    vesktop
  ];

  services.arrpc.enable = true;
}
