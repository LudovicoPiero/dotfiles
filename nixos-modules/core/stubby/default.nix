{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mine.stubby;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.mine.stubby.enable = mkEnableOption "stubby";

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.mine.dnscrypt.enable;
        message = "You can't enable both stubby & dnscrypt";
      }
    ];

    networking = {
      networkmanager.dns = "none";
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
    };

    services.stubby = {
      enable = true;
      settings = pkgs.stubby.passthru.settingsExample // {
        upstream_recursive_servers = [
          {
            address_data = "174.138.29.175";
            tls_auth_name = "dot.tiar.app";
            tls_port = 853;
          }
        ];
      };
    };
  };
}
