{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [ webcord-vencord ];

    xdg.configFile = {
      "WebCord/Themes/amoled" = {
        source = "${inputs.amoledcord}/src/amoled-cord.css";
      };
    };
  };
}
