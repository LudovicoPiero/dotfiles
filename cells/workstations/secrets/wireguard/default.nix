{ ... }:
{
  sops = {
    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = [ "/home/airi/.ssh/id_ed25519" ];
    age.keyFile = "/home/airi/.config/sops/age/keys.txt";
    # This will generate a new key if the key specified above does not exist
    age.generateKey = true;
  };
}
