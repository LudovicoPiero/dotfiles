#!/usr/bin/env bash
# Dependencies: tesseract, grim, slurp, wl-clipboard, libnotify

# 1. Select region
GEOM=$(slurp)
if [ "$GEOM" = "" ]; then exit 1; fi

# 2. Extract Text (English + Indonesian + Japanese)
TEXT=$(grim -g "$GEOM" -t ppm - | tesseract -l eng+ind+jpn --psm 6 - -)

# 3. Validation
if [[ -z "${TEXT//[[:space:]]/}" ]]; then
  notify-send -u low "OCR Failed" "No readable text found."
  exit 1
fi

# 4. Copy to clipboard
echo "$TEXT" | tr -d '\0' | wl-copy

# 5. Notification
PREVIEW=$(echo "$TEXT" | tr '\n' ' ' | cut -c 1-60)
if [ ${#TEXT} -gt 60 ]; then PREVIEW="${PREVIEW}..."; fi
notify-send "OCR Copied" "$PREVIEW"
