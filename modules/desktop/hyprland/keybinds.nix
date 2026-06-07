{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe getExe' mkIf;
  cfg = config.mine.hyprland;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/lua/keybinds.lua".text = ''
      local mod = "SUPER"

      hl.bind(mod .. " + Return", hl.dsp.exec_cmd("${
        getExe pkgs.${config.mine.vars.terminal}
      }"))
      hl.bind(mod .. " + E", hl.dsp.exec_cmd("${getExe' pkgs.emacs "emacsclient"} -c"))
      hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("${getExe pkgs.thunar}"))
      hl.bind(mod .. " + M", hl.dsp.exec_cmd("${getExe pkgs.thunderbird}"))
      hl.bind(mod .. " + P", hl.dsp.exec_cmd("${getExe pkgs.rofi} -show drun"))
      hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("${getExe pkgs.rofi} -show window"))

      hl.bind(mod .. " + O", hl.dsp.exec_cmd("clipboard-picker"))

      hl.bind("print", hl.dsp.exec_cmd("wl-ocr"))
      hl.bind("ALT + print", hl.dsp.exec_cmd("screenshot"))
      hl.bind("CTRL + print", hl.dsp.exec_cmd("${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -"))

      hl.bind(mod .. " + X", hl.dsp.exec_cmd("${getExe pkgs.wleave}"))
      hl.bind(mod .. " + W", hl.dsp.window.close())
      hl.bind(mod .. " + SHIFT + C", hl.dsp.exit())
      hl.bind(mod .. " + Q", hl.dsp.workspace.toggle_special(""))
      hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.move({ workspace = "special" }))
      hl.bind(mod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))
      hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + R", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
      hl.bind(mod .. " + SHIFT + J", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))
      hl.bind(mod .. " + SHIFT + K", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive b"))

      hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))

      hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
      hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
      hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

      for i = 1, 10 do
          local key = i % 10
          hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, silent = true }))
      end

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${getExe pkgs.brightnessctl} -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${getExe pkgs.brightnessctl} -e4 -n2 set 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${getExe pkgs.playerctl} play-pause"), { locked = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${getExe pkgs.playerctl} next"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${getExe pkgs.playerctl} previous"), { locked = true })

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };
}
