{
  pkgs,
  config,
  ...
}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam-small.override {
      extraEnv = {
        AMD_VULKAN_ICD = config.environment.sessionVariables.AMD_VULKAN_ICD;
      };
    };
  };

  /*
  Enable udev rules for Steam hardware such as the Steam Controller,
  other supported controllers and the HTC Vive
  */
  hardware.steam-hardware.enable = true;
}
