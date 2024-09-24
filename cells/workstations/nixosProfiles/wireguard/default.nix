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
      address = [ "10.66.66.3/32" ];
      dns = [
        "174.138.21.128"
      ];
      privateKeyFile = config.sops.secrets.privateKey.path;

      peers = [
        {
          publicKey = "5O8KBoWspfzTO+o8DyxSyb5Yk9csvQfFs59Y2FujTAA=";
          presharedKeyFile = config.sops.secrets.presharedKey.path;
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "45.76.153.239:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
