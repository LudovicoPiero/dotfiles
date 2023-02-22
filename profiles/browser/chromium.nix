{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium; # with ungoogled, you can't install extensions from the settings below
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "jhnleheckmknfcgijgkadoemagpecfol";} # Auto-Tab-Discard
        {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
        }
        {
          id = "ilcacnomdmddpohoakmgcboiehclpkmj";
          updateUrl = "https://raw.githubusercontent.com/FastForwardTeam/releases/main/update/update.xml";
        }
      ];
    };
  };
}
