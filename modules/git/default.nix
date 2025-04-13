{
  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfpKHR5JwyGCxZTGqz6Gasn0KlhEqj61eScYGOiF7Wz";
      signByDefault = true;
    };
    extraConfig = {
      gpg = {
        format = "ssh";
      };
    };
  };
}
