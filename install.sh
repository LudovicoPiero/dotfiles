#!/usr/bin/env sh

# Gentoo Package Installer Script
# Reads from packages.txt and merges them into @world

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run as root (sudo).${NC}"
  exit 1
fi

# Check for packages.txt
if [ ! -f "packages.txt" ]; then
    echo -e "${RED}Error: packages.txt not found in current directory!${NC}"
    exit 1
fi

echo -e "${GREEN}Reading package list from packages.txt...${NC}"

# Read packages, ignoring comments and empty lines
PACKAGES=$(grep -vE "^\s*#" packages.txt | tr '\n' ' ')

if [ -z "$PACKAGES" ]; then
    echo -e "${RED}Error: packages.txt is empty or invalid.${NC}"
    exit 1
fi

echo -e "${GREEN}Calculating dependencies and installing packages...${NC}"
echo "This may take a while depending on binary availability and compilation times."

# Emerge flags:
# --ask: Confirm before starting
# --verbose: Show details
# --noreplace: Don't re-merge if already installed/up-to-date
# --keep-going: Don't stop the whole build if one non-critical package fails
emerge --ask --verbose --noreplace --keep-going $PACKAGES

echo -e "${GREEN}Done! run 'dispatch-conf' if configuration updates are needed.${NC}"
