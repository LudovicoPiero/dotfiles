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
          "1.0.0.1"
        ];
        privateKeyFile = config.sops.secrets.privateKey.path;

        peers = [
          {
            publicKey = "TObe/TS8DmfD1u42rc/lW95EJ3EcSHy18cQIRWW/cBY=";
            presharedKeyFile = config.sops.secrets.presharedKey.path;
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "139.180.221.129:60383";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
