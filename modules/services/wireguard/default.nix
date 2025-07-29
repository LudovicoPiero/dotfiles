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
        autostart = true;
        address = [ "10.66.66.3/32" ];
        dns = [
          "45.90.28.49"
          "1.0.0.1"
        ];
        privateKeyFile = config.sops.secrets.privateKey.path;

        peers = [
          {
            publicKey = "lmskSqj03H02xi5AT21+3aZlnG6Ck6WoUTLnDarIVBU=";
            presharedKeyFile = config.sops.secrets.presharedKey.path;
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "139.180.221.129:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
