{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (config.mine) vars;

  cfg = config.mine.tlp;
in
{
  options.mine.tlp = {
    enable = mkEnableOption "TLP power management" // {
      # Automatically enable if isALaptop is true, unless explicitly disabled
      default = vars.isALaptop;
    };
  };

  config = mkIf cfg.enable {
    services = {
      # TLP conflicts with power-profiles-daemon (default in GNOME/KDE)
      power-profiles-daemon.enable = mkForce false;

      tlp = {
        enable = true;
        settings = {
          # CPU
          CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          # Boost
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;

          # GPU (AMD specific)
          AMDGPU_ABM_LEVEL_ON_AC = 0;
          AMDGPU_ABM_LEVEL_ON_BAT = 3;
          RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
          RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

          # Platform
          PLATFORM_PROFILE_ON_AC = "balanced";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          # Runtime PM
          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";

          # Battery Charging Thresholds
          # NOTE: Ensure your battery is actually BAT1. Many are BAT0.
          # You can check with `ls /sys/class/power_supply/`
          START_CHARGE_THRESH_BAT1 = "85";
          STOP_CHARGE_THRESH_BAT1 = "90";
        };
      };
    };
  };
}
