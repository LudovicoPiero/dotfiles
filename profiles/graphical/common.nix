{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      (discord-canary.override {
        nss = pkgs.nss_latest;
        withOpenASAR = true;
      })
      webcord
      nur.repos.baduhai.chatterino7
      tdesktop
    ];
  };
}
