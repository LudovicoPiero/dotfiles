{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.rofi;
  c = config.mine.theme.colors;
in
{
  options.mine.rofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Rofi configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rofi;
      description = "The Rofi package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];
      xdg.config = {
        files = {
          "rofi/config.rasi".text = ''
            configuration {
                modi:                       ["drun", "run", "filebrowser", "window"];
                font: "${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}";
                terminal:                   "${config.mine.vars.terminal}";
                show-icons:                 true;
                display-drun:               "";
                display-run:                "";
                display-filebrowser:        "";
                display-window:             "";
                display-emoji:              "😅";
                drun-display-format:        "{icon} {name}";
                window-format:              "{w} · {c} · {t}";

                kb-row-up:                  "Up,Control+p";
                kb-row-down:                "Down,Control+n";
                kb-move-char-back:          "Left,Control+b";
                kb-move-char-forward:       "Right,Control+f";
                kb-remove-to-eol:           "";

                kb-accept-entry:            "Control+m,Return,KP_Enter";

                click-to-exit:              true;
                hover-select:               false;

                filebrowser {
                    directories-first: true;
                    sorting-method:    "name";
                }
            }

            @theme "tokyonight-big1.rasi"
          '';

          "rofi/tokyonight-big1.rasi".text = ''
            * {
                bg: ${c.base01};
                hv: ${c.base0E};
                primary: ${c.base05};
                ug: ${c.base02};
                font: "${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}";
                background-color: @bg;
                border: 0px;
                kl: ${c.base0D};
                black: ${c.base00};
                transparent: rgba(0,0,0,0);
            }

            window {
                width: 700;
                orientation: horizontal;
                location: center;
                anchor: center;
                transparency: "screenshot";
                border-color: @transparent;
                border: 0px;
                border-radius: 6px;
                spacing: 0;
                children: [ mainbox ];
            }

            mainbox {
                spacing: 0;
                children: [ inputbar, message, listview ];
            }

            inputbar {
                color: @kl;
                padding: 11px;
                border: 3px 3px 2px 3px;
                border-color: @primary;
                border-radius: 6px 6px 0px 0px;
            }

            message {
                padding: 0;
                border-color: @primary;
                border: 0px 1px 1px 1px;
            }

            entry, prompt, case-indicator {
                text-font: inherit;
                text-color: inherit;
            }

            entry {
                cursor: pointer;
            }

            prompt {
                margin: 0px 5px 0px 0px;
            }

            listview {
                layout: vertical;
                padding: 8px;
                lines: 7;
                columns: 1;
                border: 0px 3px 3px 3px;
                border-radius: 0px 0px 6px 6px;
                border-color: @primary;
                dynamic: false;
            }

            element {
                padding: 2px;
                vertical-align: 1;
                color: @kl;
                font: inherit;
            }

            element-text {
                background-color: inherit;
                text-color: inherit;
                vertical-align: 0.5;
            }

            element selected.normal {
                color: @black;
                background-color: @hv;
            }

            element normal active {
                background-color: @hv;
                color: @black;
            }

            element-icon {
                background-color: inherit;
                text-color: inherit;
                size: 2.5em;
            }

            element normal urgent {
                background-color: @primary;
            }

            element selected active {
                background: @hv;
                foreground: @bg;
            }

            button {
                padding: 6px;
                color: @primary;
                horizonatal-align: 0.5;
                border: 2px 0px 2px 2px;
                border-radius: 4px 0px 0px 4px;
                border-color: @primary;
            }

            button selected normal {
                border: 2px 0px 2px 2px;
                border-color: @primary;
            }
          '';

          "rofi/tokyonight.rasi".text = ''
            * {
                bg: ${c.base01};
                hv: ${c.base0E};
                primary: ${c.base05};
                ug: ${c.base02};
                font: "${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}";
                background-color: @bg;
                border: 0px;
                kl: ${c.base0D};
                black: ${c.base00};
                transparent: rgba(0,0,0,0);
            }

            window {
                width: 700;
                orientation: horizontal;
                location: center;
                anchor: center;
                transparency: "screenshot";
                border-color: @primary;
                border: 3px;
                border-radius: 6px;
                spacing: 0;
                children: [ mainbox ];
            }

            mainbox {
                spacing: 0;
                children: [ inputbar, message, listview ];
            }

            inputbar {
                color: @kl;
                padding: 11px;
                border: 0 0 2px 0;
                border-color: @primary;
            }

            message {
                padding: 0;
            }

            textbox {
                color: @kl;
                padding: 10px;
            }

            entry, prompt, case-indicator {
                text-font: inherit;
                text-color: inherit;
            }

            entry {
                cursor: pointer;
            }

            prompt {
                margin: 0px 5px 0px 0px;
            }

            listview {
                layout: vertical;
                padding: 8px;
                lines: 12;
                columns: 1;
                dynamic: false;
            }

            element {
                padding: 2px;
                vertical-align: 1;
                color: @kl;
                font: inherit;
            }

            element-text {
                background-color: inherit;
                text-color: inherit;
            }

            element selected.normal {
                color: @black;
                background-color: @hv;
            }

            element normal active {
                background-color: @hv;
                color: @black;
            }

            element-text, element-icon {
                background-color: inherit;
                text-color: inherit;
            }

            element normal urgent {
                background-color: @primary;
            }

            element selected active {
                background: @hv;
                foreground: @bg;
            }

            button {
                padding: 6px;
                color: @primary;
                horizonatal-align: 0.5;
                border: 2px 0px 2px 2px;
                border-radius: 4px 0px 0px 4px;
                border-color: @primary;
            }

            button selected normal {
                border: 2px 0px 2px 2px;
                border-color: @primary;
            }

            scrollbar {
                enabled: true;
            }
          '';
        };
      };
    };
  };
}
