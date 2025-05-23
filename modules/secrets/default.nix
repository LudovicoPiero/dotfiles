{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.mine.secrets = {
    enable = mkEnableOption "secrets";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.sshKeyPaths = [ "/Persist/ssh/id_ed25519_sops" ];
      age.keyFile = "/Persist/sops/age/keys.txt";
    };
  };
}
