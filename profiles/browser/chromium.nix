{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "jhnleheckmknfcgijgkadoemagpecfol";} # Auto-Tab-Discard
        {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark-Reader
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
