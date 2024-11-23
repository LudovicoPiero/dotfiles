{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.myOptions.secrets;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options.myOptions.secrets = {
    enable =
      mkEnableOption "secrets"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.sshKeyPaths = ["/home/airi/.ssh/id_ed25519_sops"];
    sops.age.keyFile = "/home/airi/.config/sops/age/keys.txt";
    sops.secrets."users/userPassword".neededForUsers = true;
    sops.secrets."users/rootPassword".neededForUsers = true;
  };
}
