#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

# 1. Pick the poison (Corrected)
# We group the find commands { ...; } and pipe the output to fzf,
# then capture the FINAL selection into the variable.
FILE=$({
  find ~/.config -maxdepth 1 -mindepth 1 -type d
  find ~ -maxdepth 1 -type f -name ".*"
} |
  fzf --prompt="Pick a config to steal: " --height=40% --reverse)

# Exit if user hits ESC
[ -z "$FILE" ] && exit 0

FILE=$(realpath "$FILE")
BASENAME=$(basename "$FILE")

# 2. Name the package
read -e -p "Package name [$BASENAME]: " PKG
PKG=${PKG:-$BASENAME}

# 3. Calculate paths
if [[ "$FILE" == *"$HOME/.config"* ]]; then
  # Keep it inside .config structure
  DEST_DIR="$DOTFILES/$PKG/.config"
  FINAL_PATH="$DEST_DIR/$BASENAME"
else
  # It's a root dotfile (like .zshrc)
  DEST_DIR="$DOTFILES/$PKG"
  FINAL_PATH="$DEST_DIR/$BASENAME"
fi

# 4. Move and Stow
echo "Moving $FILE -> $FINAL_PATH..."
mkdir -p "$DEST_DIR"
mv "$FILE" "$FINAL_PATH"

echo "Stowing $PKG..."
cd "$DOTFILES" || exit
stow "$PKG"

echo "Done. $PKG is now assimilated."
