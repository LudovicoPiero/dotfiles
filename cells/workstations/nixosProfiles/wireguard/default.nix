{
  cell,
  inputs,
  config,
  ...
}:
let
  inherit (cell) secrets;
in
{
  imports = [ secrets.wireguard ];

  sops.secrets = {
    privateKey = {
      sopsFile = "${inputs.self}/cells/workstations/secrets/wireguard.yaml";
    };
    presharedKey = {
      sopsFile = "${inputs.self}/cells/workstations/secrets/wireguard.yaml";
    };
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = true;
      address = [ "10.66.66.2/32" ];
      dns = [
        "127.0.0.1"
        "174.138.21.128"
      ];
      privateKeyFile = config.sops.secrets.privateKey.path;

      peers = [
        {
          publicKey = "1merpuLyqsIpEIa/VJs1yQxHAc2XFfSqCLSRY5ubOWc=";
          presharedKeyFile = config.sops.secrets.presharedKey.path;
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "64.176.58.166:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
