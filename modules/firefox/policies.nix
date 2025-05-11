{ config, lib, ... }:
let
  cfg = config.myOptions.firefox;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    programs.firefox.policies = {
      AppAutoUpdate = false;
      FirefoxSuggest = {
        "SponsoredSuggestions" = false;
      };
      DisableTelemetry = true;
      HardwareAcceleration = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      SSLVersionMin = "tls1.2";
      # REF https://mozilla.github.io/policy-templates/#extensions
      # NOTE find UUID for each extension in about:debugging#/runtime/this-firefox
      Extensions = {
        Locked = [
          "uBlock0@raymondhill.net"
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" # refined github
          "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" # search by image
          "sponsorBlocker@ajay.app"
          "{db420ff1-427a-4cda-b5e7-7d395b9f16e1}" # toDeepL
        ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"; # using slug / short name
        };
        "sponsorBlocker@ajay.app" = {
          default_area = "navbar";
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          default_area = "navbar";
          "installation_mode" = "force_installed";
          "install_url" =
            "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        };
        "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/search_by_image/latest.xpi";
        };
        "{db420ff1-427a-4cda-b5e7-7d395b9f16e1}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/to-deepl/latest.xpi";
        };
      };
    };
  };
}
