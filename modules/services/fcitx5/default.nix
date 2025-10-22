{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.fcitx5;
  localeCfg = cfg.locale;
in
{
  options.mine = {
    fcitx5 = {
      enable = mkEnableOption "fcitx5 service";

      locale = {
        defaultLocale = lib.mkOption {
          type = lib.types.str;
          default = "ja_JP.UTF-8";
          description = "Default system locale";
        };
        extraLocales = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "ja_JP.UTF-8"
            "en_US.UTF-8/UTF-8"
          ];
          description = "List of additional locales to generate";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    hm = {
      home.language.base = localeCfg.defaultLocale;
    };

    i18n = {
      # Locale Settings
      inherit (localeCfg) defaultLocale;
      inherit (localeCfg) extraLocales;
      extraLocaleSettings = {
        LANGUAGE = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
        LC_CTYPE = "ja_JP.UTF-8";
        LC_ADDRESS = "ja_JP.UTF-8";
        LC_IDENTIFICATION = "ja_JP.UTF-8";
        LC_MEASUREMENT = "ja_JP.UTF-8";
        LC_MESSAGES = "ja_JP.UTF-8";
        LC_MONETARY = "ja_JP.UTF-8";
        LC_NAME = "ja_JP.UTF-8";
        LC_NUMERIC = "ja_JP.UTF-8";
        LC_PAPER = "ja_JP.UTF-8";
        LC_TELEPHONE = "ja_JP.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
        LC_COLLATE = "ja_JP.UTF-8";
      };

      # The Real FCITX5 Settings
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            # Languages
            fcitx5-mozc # Japanese
            fcitx5-hangul # Korean

            # Input methods Module
            (libsForQt5.fcitx5-qt.overrideAttrs (old: {
              patches = old.patches or [ ] ++ [
                (pkgs.fetchpatch2 {
                  url = "https://github.com/fcitx/fcitx5-qt/commit/46a07a85d191fd77a1efc39c8ed43d0cd87788d2.patch?full_index=1";
                  hash = "sha256-qv8Rj6YoFdMQLOB2R9LGgwCHKdhEji0Sg67W37jSIac=";
                })
                (pkgs.fetchpatch2 {
                  url = "https://github.com/fcitx/fcitx5-qt/commit/6ac4fdd8e90ff9c25a5219e15e83740fa38c9c71.patch?full_index=1";
                  hash = "sha256-x0OdlIVmwVuq2TfBlgmfwaQszXLxwRFVf+gEU224uVA=";
                })
                (pkgs.fetchpatch2 {
                  url = "https://github.com/fcitx/fcitx5-qt/commit/1d07f7e8d6a7ae8651eda658f87ab0c9df08bef4.patch?full_index=1";
                  hash = "sha256-22tKD7sbsTJcNqur9/Uf+XAvMvA7tzNQ9hUCMm+E+E0=";
                })
              ];
            }))

            # Theme
            inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.catppuccin-fcitx5
          ];

          settings = {
            inputMethod = {
              "GroupOrder" = {
                "0" = "Keys";
              };
              "Groups/0" = {
                Name = "Keys";
                "Default Layout" = "us";
                "DefaultIM" = "keyboard-us";
              };
              "Groups/0/Items/0" = {
                Name = "mozc";
                "Layout" = "";
              };
              "Groups/0/Items/1" = {
                Name = "keyboard-us";
                "Layout" = "";
              };
              "Groups/0/Items/2" = {
                Name = "hangul";
                "Layout" = "us";
              };
            };

            globalOptions = {
              Hotkey = {
                EnumerateWithTriggerKeys = true;
                EnumerateSkipFirst = false;
                ActivateKeys = "";
                DeactivateKeys = "";
              };

              "Hotkey/TriggerKeys" = {
                "0" = "Control+Shift+space";
              };
              "Hotkey/AltTriggerKeys" = {
                "0" = "Page_Up";
              };
              "Hotkey/EnumerateForwardKeys" = {
                "0" = "Control+Shift_L";
              };
              "Hotkey/EnumerateBackwardKeys" = {
                "0" = "Control+Shift_R";
              };
              "Hotkey/EnumerateGroupForwardKeys" = {
                "0" = "Super+space";
              };
              "Hotkey/EnumerateGroupBackwardKeys" = {
                "0" = "Shift+Super+space";
              };
              "Hotkey/PrevPage" = {
                "0" = "Up";
              };
              "Hotkey/NextPage" = {
                "0" = "Down";
              };
              "Hotkey/PrevCandidate" = {
                "0" = "Shift+Tab";
              };
              "Hotkey/NextCandidate" = {
                "0" = "Tab";
              };
              "Hotkey/TogglePreedit" = {
                "0" = "Control+Alt+P";
              };

              Behavior = {
                ActiveByDefault = true;
                ShareInputState = "No";
                PreeditEnabledByDefault = true;
                ShowInputMethodInformation = true;
                showInputMethodInformationWhenFocusIn = false;
                CompactInputMethodInformation = true;
                ShowFirstInputMethodInformation = true;
                DefaultPageSize = 5;
                OverrideXkbOption = false;
                CustomXkbOption = "";
                EnabledAddons = "";
                DisabledAddons = "";
                PreloadInputMethod = true;
              };
            };

            addons = {
              classicui.globalSection = {
                "Theme" = "catppuccin-mocha";
                "DarkTheme" = "default-dark";
                "Font" = "${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}";
                "MenuFont" = "${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}";
                "TrayFont" = "${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}";
                "UseDarkTheme" = true;
                "PerScreenDPI" = false;
                "ForceWaylandDPI" = false;
                "EnableFractionalScale" = true;
                "ShowLayoutNameInIcon" = true;
                "PreferTextIcon" = true;
                "TrayOutlineColor" = "#${palette.base00}";
                "TrayTextColor" = "#${palette.base05}";
                "Vertical Candidate List" = false;
                "WheelForPaging" = true;
              };
            };
          };
        };
      };
    };

    hm = {
      systemd.user.services.fcitx5 = {
        Unit = {
          Description = "Input method framework";
          BindsTo = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          Restart = "on-failure";
          ExecStart = "${lib.getExe pkgs.fcitx5}";
        };
      };
    };
  };
}
