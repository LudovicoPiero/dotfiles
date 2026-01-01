#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

# 1. Pick the file (Updated to filter out garbage)
# We exclude history files, Xauthority, and .git folders
FILE=$( {
    find ~/.config -maxdepth 1 -mindepth 1 -type d; \
    find ~ -maxdepth 1 -type f -name ".*" \
         ! -name .bash_history \
         ! -name .zsh_history \
         ! -name .lesshst \
         ! -name .viminfo \
         ! -name .Xauthority \
         ! -name .ICEauthority \
         ! -name .xsession-errors \
         ! -name .wget-hsts; \
    } | fzf --prompt="Pick a config to steal: " --height=40% --reverse )

# Exit if cancelled
[ -z "$FILE" ] && exit 0

FILE=$(realpath "$FILE")
BASENAME=$(basename "$FILE")

# 2. Name the package
# TIP: If you chose .gtkrc-2.0, type "gtk" here to group them!
read -e -p "Package name [$BASENAME]: " PKG
PKG=${PKG:-$BASENAME}

# 3. Calculate paths
if [[ "$FILE" == *"$HOME/.config"* ]]; then
    # Case A: Inside .config (e.g. ~/.config/nvim)
    # Target: ~/dotfiles/nvim/.config/nvim
    DEST_DIR="$DOTFILES/$PKG/.config"
    FINAL_PATH="$DEST_DIR/$BASENAME"
else
    # Case B: Root dotfile (e.g. ~/.gtkrc-2.0)
    # Target: ~/dotfiles/gtk/.gtkrc-2.0
    DEST_DIR="$DOTFILES/$PKG"
    FINAL_PATH="$DEST_DIR/$BASENAME"
fi

# 4. Move and Stow
echo "Moving $FILE -> $FINAL_PATH..."
mkdir -p "$DEST_DIR"
mv "$FILE" "$FINAL_PATH"

echo "Stowing $PKG..."
cd "$DOTFILES" || exit
stow -R "$PKG"

echo "Done. $PKG is now assimilated."
