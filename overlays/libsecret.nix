self: super: {
  libsecret = super.libsecret.overrideAttrs (o: {
    doCheck = false;
  });
}
