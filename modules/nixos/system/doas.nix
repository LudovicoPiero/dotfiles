{
  security = {
    sudo.enable = false;
    polkit.enable = true;
    doas = {
      enable = true;
      extraRules = [{
        users = [ "ludovico" ];
        keepEnv = true;
        persist = true;
      }];
    };

    # Extra security
    protectKernelImage = true;
  };
}
