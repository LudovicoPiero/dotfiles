{
  pkgs,
  config,
  inputs,
  ...
}: let
  amoledcord = pkgs.fetchFromGitHub {
    owner = "LuckFire";
    repo = "amoled-cord";
    rev = "6491eb350e54bb336e38bf7e552d4b57eea11626";
    hash = "sha256-wu7Wb2yskH+41oLkETZqHFomr8057femirWQacfo9PE=";
  };
in {
  home-manager.users."${config.vars.username}" = {
    imports = [
      inputs.arrpc.homeManagerModules.default
    ];

    home.packages = with pkgs; [
      webcord-vencord
    ];

    xdg.configFile = {
      "WebCord/Themes/amoled" = {
        source = "${amoledcord}/src/amoled-cord.css";
      };
    };

    services.arrpc.enable = true;
  };
}
