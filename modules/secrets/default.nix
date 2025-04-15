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
    enable = mkEnableOption "secrets" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.sshKeyPaths = [ "/home/${config.vars.username}/.ssh/id_ed25519_sops" ];
      age.keyFile = "/home/${config.vars.username}/.config/sops/age/keys.txt";
    };
  };
}
