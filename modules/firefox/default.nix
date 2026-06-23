{ inputs, pkgs, ... }: {
  imports = [
    ./search.nix
    ./settings.nix
  ];

  hm = {
    programs.firefox = {
      enable = true;

      profiles.ludovico = {
        isDefault = true;
        extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            bitwarden
            vimium
            sponsorblock
          ];
        };
      };
    };
  };
}
