{ pkgs, inputs, ... }:
{

  home.packages = with inputs.master.legacyPackages.${pkgs.system}; [
    webcord-vencord
    vesktop
  ];
}
