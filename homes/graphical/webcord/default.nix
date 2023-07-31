{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = with pkgs; [
    webcord-vencord
  ];

  xdg.configFile = {
    "WebCord/Themes/amoled" = {
      source = "${inputs.amoledcord}/src/amoled-cord.css";
    };
  };

  services.arrpc.enable = true;
}
