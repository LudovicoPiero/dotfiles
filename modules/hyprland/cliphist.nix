{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.cliphist;
in
{
  options.mine.cliphist = {
    enable = mkEnableOption "cliphist service";
  };

  config = mkIf cfg.enable {
    hm = {
      services.cliphist = {
        enable = true;
        allowImages = true;
        extraOptions = [
          "-max-dedupe-search"
          "10"
          "-max-items"
          "500"
        ];
      };
    };
  };
}
