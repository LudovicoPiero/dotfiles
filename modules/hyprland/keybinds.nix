{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkIf
    mkAfter
    ;
  cfg = config.mine.hyprland;

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    DIR="$HOME/Pictures/Screenshots"
    FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

    mkdir -p "$DIR"

    # Select area (slurp) -> Capture (grim) -> Save to file
    ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" "$FILE"

    # Copy image to clipboard
    ${getExe' pkgs.wl-clipboard "wl-copy"} < "$FILE"

    # Send Notification
    ${getExe pkgs.libnotify} "Screenshot taken" "Saved to $FILE" -i "$FILE"
  '';

  wl-ocr = pkgs.writeShellScriptBin "wl-ocr" ''
    ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - | ${getExe pkgs.tesseract} - - | ${getExe' pkgs.wl-clipboard "wl-copy"}
    ${getExe pkgs.libnotify} "OCR" "Text copied to clipboard"
  '';

  clipboard-picker = pkgs.writeShellScriptBin "clipboard-picker" ''
    ${getExe pkgs.cliphist} list | ${getExe pkgs.rofi} -dmenu display-columns 2 | ${getExe pkgs.cliphist} decode | ${getExe' pkgs.wl-clipboard "wl-copy"}
  '';
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
      # KEYBINDINGS
      $mod = SUPER

      # Apps (Using getExe)
      bind = $mod, Return, exec, ${getExe pkgs.${config.mine.vars.terminal}}
      bind = $mod, E, exec, ${getExe' pkgs.emacs "emacsclient"} -c
      bind = $mod SHIFT, E, exec, ${getExe pkgs.thunar}
      bind = $mod, M, exec, ${getExe pkgs.thunderbird}
      bind = $mod, P, exec, ${getExe pkgs.rofi} -show drun
      bind = $mod SHIFT, P, exec, ${getExe pkgs.rofi} -show window
      # bind = $mod, D, exec, ${getExe pkgs.vesktop}
      # bind = $mod, G, exec, ${getExe pkgs.firefox}

      # Custom Scripts
      bind = $mod, O, exec, ${getExe clipboard-picker}

      # Screenshots & OCR
      bind = , print, exec, ${getExe wl-ocr}
      bind = ALT, Print, exec, ${getExe screenshot}
      bind = CTRL, Print, exec, ${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -

      # Window Management
      bind = $mod, X, exec, ${getExe pkgs.wleave}
      bind = $mod, W, killactive
      bind = $mod SHIFT, C, exit
      bind = $mod, Q, togglespecialworkspace
      bind = $mod SHIFT, Q, movetoworkspace, special
      bind = $mod, F, fullscreen, 0
      bind = $mod, Space, togglefloating
      bind = $mod, R, togglegroup
      bind = $mod SHIFT, J, changegroupactive, f
      bind = $mod SHIFT, K, changegroupactive, b

      # Focus & Move (Vim)
      bind = $mod, h, movefocus, l
      bind = $mod, l, movefocus, r
      bind = $mod, k, movefocus, u
      bind = $mod, j, movefocus, d

      bind = $mod SHIFT, h, movewindow, l
      bind = $mod SHIFT, l, movewindow, r
      bind = $mod SHIFT, k, movewindow, u
      bind = $mod SHIFT, j, movewindow, d

      # Workspaces
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10

      bind = $mod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mod SHIFT, 0, movetoworkspacesilent, 10

      # Media Keys
      bindel = , XF86AudioRaiseVolume, exec, ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
      bindel = , XF86AudioMute, exec, ${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = , XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} -e4 -n2 set 5%+
      bindel = , XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} -e4 -n2 set 5%-
      bindl = , XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause
      bindl = , XF86AudioNext, exec, ${getExe pkgs.playerctl} next
      bindl = , XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous

      # Mouse
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow
    '';
  };
}
