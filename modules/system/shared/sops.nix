{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # This is using an age key that is expected to already be in the filesystem
    age.keyFile = "/persist/sops/age/keys.txt";

    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = [ "/persist/ssh/id_ed25519_sops" ];
  };
}
