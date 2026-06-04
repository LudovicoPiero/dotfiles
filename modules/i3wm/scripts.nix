{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
  cfg = config.mine.i3;

  x11-screenshot = pkgs.writeShellScriptBin "x11-screenshot" ''
    DIR="$HOME/Pictures/Screenshots"
    FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
    mkdir -p "$DIR"
    ${getExe pkgs.maim} -s "$FILE"
    ${getExe pkgs.xclip} -selection clipboard -t image/png -i "$FILE"
    ${getExe pkgs.libnotify} "Screenshot taken" "Saved to $FILE" -i "$FILE"
  '';

  x11-ocr = pkgs.writeShellScriptBin "x11-ocr" ''
    ${getExe pkgs.maim} -s | ${getExe pkgs.tesseract} - - | ${getExe pkgs.xclip} -selection clipboard
    ${getExe pkgs.libnotify} "OCR" "Text copied to clipboard"
  '';

  clipboard-picker = pkgs.writeShellScriptBin "clipboard-picker" ''
    ${getExe pkgs.rofi} -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
  '';

  x11-powermenu = pkgs.writeShellScriptBin "x11-powermenu" ''
    CHOSEN=$(printf "Lock\nSuspend\nReboot\nShutdown\nLog Out" | ${getExe pkgs.rofi} -dmenu -i -p "Power")
    case "$CHOSEN" in
      "Lock") ${getExe pkgs.xset} s activate ;;
      "Suspend") systemctl suspend ;;
      "Reboot") systemctl reboot ;;
      "Shutdown") systemctl poweroff ;;
      "Log Out") i3-msg exit ;;
    esac
  '';
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = [
      x11-screenshot
      x11-ocr
      clipboard-picker
      x11-powermenu
    ];
  };
}
