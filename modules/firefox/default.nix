{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.firefox;
in
{
  imports = [
    ./preferences.nix
    ./policies.nix
  ];

  options.myOptions.firefox = {
    enable = mkEnableOption "firefox browser" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      #NOTE:
      # Use firefox-esr because some policies only works in ESR
      package = pkgs.firefox-esr;
    };

    hj.files =
      let
        inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) firefox-ui-fix;
      in
      {
        ".mozilla/firefox/profiles.ini".text = ''
          [General]
          StartWithLastProfile=1
          Version=2

          [Profile0]
          Name=${config.vars.username}
          IsRelative=1
          Path=${config.vars.username}
          Default=1
        '';

        ".mozilla/firefox/${config.vars.username}/chrome/userChrome.css".text = ''
          @import "${firefox-ui-fix}/css/leptonChromeESR.css";

          .tabbrowser-tab {
             min-height: 30px !important;
             max-height: 34px !important;
             box-shadow: none !important;
          }

          #TabsToolbar #tabs-newtab-button {
             margin-top: -5px !important;
             margin-bottom: -8px !important;
             margin-left: 0px !important;
          }
        '';
        ".mozilla/firefox/${config.vars.username}/chrome/userContent.css".text = ''
          @import "${firefox-ui-fix}/css/leptonContentESR.css";
        '';
      };
  };
}
