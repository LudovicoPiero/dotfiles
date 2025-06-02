{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.wireguard;
in
{
  options.mine.wireguard = {
    enable = mkEnableOption "wireguard service";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      presharedKey = { };
      privateKey = { };
    };

    networking.wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [ "10.66.66.3/32" ];
        dns = [
          "45.90.28.49"
          "45.90.30.49"
        ];
        privateKeyFile = config.sops.secrets.privateKey.path;

        peers = [
          {
            publicKey = "Bnw+4BTkjhJDpSZ9uFylkpDoqOFY5GWtcaAqGvakNjk=";
            presharedKeyFile = config.sops.secrets.presharedKey.path;
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "139.180.209.122:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
