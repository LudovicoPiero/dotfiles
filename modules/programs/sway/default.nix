{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    ;

  cfg = config.mine.sway;
in
{
  imports = [
    ./config.nix
    ./bars.nix
    ./keybindings.nix
    ./window.nix
  ];

  options.mine.sway = {
    enable = mkEnableOption "sway";

    withUWSM = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.withUWSM {
      programs.uwsm = {
        enable = true;
        waylandCompositors.sway = {
          binPath = "/etc/profiles/per-user/airi/bin/sway";
          prettyName = "Sway";
          comment = "Sway managed by UWSM";
        };
      };

      environment.sessionVariables = {
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "scope";
      };
    })

    {
      hm = {
        wayland.windowManager.sway = {
          enable = true;
          systemd.enable = true;
        };

        programs.i3status-rust = {
          enable = true;
          bars.default = {
            theme = "ctp-macchiato";
            icons = "none";
            blocks = [
              {
                block = "net";
                device = "wlp4s0";
                format = " IP LEAK: $ip ";
                inactive_format = " W: down ";
              }
              {
                block = "net";
                device = "enp3s0";
                format = " IP LEAK: $ip ";
                inactive_format = " E: down ";
              }
              {
                block = "disk_space";
                path = "/";
                info_type = "available";
                interval = 30;
                warning = 10.0;
                alert = 5.0;
                format = " ROOT: $available ";
              }
              {
                block = "disk_space";
                path = "/home";
                info_type = "available";
                interval = 30;
                warning = 10.0;
                alert = 5.0;
                format = " HOME: $available ";
              }
              {
                block = "custom";
                command = "test -d /proc/sys/net/ipv4/conf/wg0 && echo ' VPN: up ' || echo ' VPN: down '";
                interval = 5;
                json = false;
              }
              {
                block = "battery";
                device = "BAT1";
                format = " BAT: $percentage $time $empty_time ";
                missing_format = " No battery ";
                full_format = " BAT: full ";
                good = 80;
                warning = 20;
                critical = 10;
              }
              {
                block = "memory";
                format = " MEM: $mem_used_percents.eng(w:1) ";
                format_alt = " MEM: $swap_free.eng(w:3,u:B,p:Mi)/$swap_total.eng(w:3,u:B,p:Mi)($swap_used_percents.eng(w:2)) ";
                interval = 30;
                warning_mem = 70;
                critical_mem = 90;
              }
              {
                block = "load";
                interval = 5;
                format = " LOAD: $1m.eng(w:4) ";
              }
              {
                block = "time";
                interval = 60;
                format = " $timestamp.datetime(f:'%Y-%m-%d %H:%M') ";
              }
            ];
          };
        };
      };
    }
  ]);
}
