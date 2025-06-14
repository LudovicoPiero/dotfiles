{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;

  cfg = config.mine.tlp;
in
{
  options.mine.tlp = {
    enable = mkEnableOption "tlp" // {
      default = config.vars.isALaptop;
    };
  };

  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = mkForce false;
      tlp = {
        enable = true;
        settings = {
          # conservative ondemand userspace powersave performance schedutil
          CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          # performance / balance_performance / default / balance_power / power
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          # 0 disable, 1 allow
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          # 0 disable, 1 enable
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;

          # 0 – off
          # 1..4 – maximum brightness reduction allowed by the ABM algorithm, 1 represents the least and 4 the most power saving
          AMDGPU_ABM_LEVEL_ON_AC = 0;
          AMDGPU_ABM_LEVEL_ON_BAT = 3;

          # performance / balanced / low-power
          PLATFORM_PROFILE_ON_AC = "balanced";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          # auto – recommended / low / high
          RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
          RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

          /*
            auto – enabled (power down idle devices)
            on – disabled (devices powered on permanently)
          */
          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";

          START_CHARGE_THRESH_BAT1 = "85";
          STOP_CHARGE_THRESH_BAT1 = "90";
        };
      };

      logind = {
        powerKey = "suspend";
        lidSwitch = "suspend-then-hibernate";
      };
    };
  };
}
