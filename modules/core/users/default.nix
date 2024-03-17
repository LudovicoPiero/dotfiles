_: {
  imports = [
    ./airi.nix
    ./root.nix
  ];

  /*
    If set to false, the contents of the user and group files will simply be replaced on system activation.
    This also holds for the user passwords; all changed passwords will be reset according to the
    users.users configuration on activation.
  */
  users.mutableUsers = false;
}
