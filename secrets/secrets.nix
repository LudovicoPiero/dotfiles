let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtzB1oiuDptWi04PAEJVpSAcvD96AL0S21zHuMgmcE9";
  user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfpKHR5JwyGCxZTGqz6Gasn0KlhEqj61eScYGOiF7Wz ludovico@sforza";

  users = [user1 user2];
in {
  "userPassword.age".publicKeys = users;
}
