{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.myOptions.secrets = {
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
      age.sshKeyPaths = [ "/home/airi/.ssh/id_ed25519_sops" ];
      age.keyFile = "/home/airi/.config/sops/age/keys.txt";
    };
  };
}
