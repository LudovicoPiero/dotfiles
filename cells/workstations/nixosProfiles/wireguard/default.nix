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
        "174.138.21.128"
        "188.166.206.224"
        "1.1.1.1"
      ];
      privateKeyFile = config.sops.secrets.privateKey.path;

      peers = [
        {
          publicKey = "xra4ritvDeDyEc5BR2btrKY8hby6MXKWKojZ7meMmE0=";
          presharedKeyFile = config.sops.secrets.presharedKey.path;
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "139.180.222.226:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
