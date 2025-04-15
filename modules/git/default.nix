{
  programs.git = {
    enable = true;
    config = {
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfpKHR5JwyGCxZTGqz6Gasn0KlhEqj61eScYGOiF7Wz";
        signByDefault = true;
      };
      gpg = {
        format = "ssh";
      };
    };
  };
}
