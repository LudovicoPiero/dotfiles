{
  cell,
  inputs,
  config,
  ...
}: let
  inherit (cell) secrets;
in {
  imports = [secrets.wireguard];

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
      address = ["10.66.66.2/32"];
      dns = ["45.76.145.144"];
      privateKeyFile = config.sops.secrets.privateKey.path;

      peers = [
        {
          publicKey = "hOxW74kF//JpljARxf4+lu+cbwgn8OtB+lXT2Tqoyhk=";
          presharedKeyFile = config.sops.secrets.presharedKey.path;
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "45.76.145.144:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
