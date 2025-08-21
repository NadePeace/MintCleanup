#!/bin/bash


# Color codes
RED='\033[0;31m'
NC='\033[0m' # No Color

set -euo pipefail
IFS=$'\n\t'

command -v apt-get >/dev/null 2>&1 || { echo -e "${RED}Error: apt-get not found (unsupported distribution).${NC}" >&2; exit 1; }

show_help() {
  sed -n '1,/^############################################################$/p' "$0" | sed 's/^# \{0,1\}//'
  echo
  echo "Current default package count: ${#applications[@]:-0}"
}

# List of applications to uninstall
applications=(
  "thunderbird"
  "thunderbird-gnome-support"
  "thunderbird-locale-en"
  "thunderbird-locale-en-gb"
  "thunderbird-locale-en-us"
  "thunderbird-locale-es"
  "thunderbird-locale-es-ar"
  "thunderbird-locale-es-es"
  "thunderbird-locale-zh-cn"
  "thunderbird-locale-zh-hans"
  "thunderbird-locale-zh-hant"
  "thunderbird-locale-zh-tw"
  "thunderbird-locale-pt"
  "thunderbird-locale-pt-br"
  "thunderbird-locale-pt-pt"
  "thunderbird-locale-de"
  "thunderbird-locale-fr"
  "thunderbird-locale-it"
  "thunderbird-locale-ru"
  "python3-uno"
  "gnome-todo"
  "gnome-calendar"
  "gnome-mines"
  "gnome-sudoku"
  "gnome-mahjongg"
  "gnome-todo-common"
  "gnome-video-effects"
  "transmission-gtk"
  "transmission-common"
  "rhythmbox"
  "rhythmbox-data"
  "rhythmbox-plugin-alternative-toolbar"
  "rhythmbox-plugins"
)

assume_yes=false
dry_run=false

while getopts ":ynh" opt; do
  case $opt in
    y) assume_yes=true ;;
    n) dry_run=true ;;
    h) show_help; exit 0 ;;
  :) echo -e "${RED}Option -$OPTARG requires an argument${NC}" >&2; exit 1 ;;
  \?) echo -e "${RED}Unknown option: -$OPTARG${NC}" >&2; show_help; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# Include extra supplied packages
if [ $# -gt 0 ]; then
  applications+=("$@")
fi

if [ ${#applications[@]} -eq 0 ]; then
  echo -e "${RED}No packages specified.${NC}" >&2
  exit 0
fi

echo "Packages scheduled for removal (${#applications[@]}):"
printf '  - %s\n' "${applications[@]}"
echo

if ! $assume_yes; then
  read -r -p "Proceed with uninstall? (y/N) " reply
  case "$reply" in
    [yY][eE][sS]|[yY]) ;;
  *) echo -e "${RED}Aborted.${NC}"; exit 0 ;;
  esac
fi

removed_any=false
for app in "${applications[@]}"; do
  echo "Processing: $app"
  if dpkg -s "$app" >/dev/null 2>&1; then
    if $dry_run; then
      echo "  (dry-run) Would remove $app"
    else
      echo "  Removing $app..."
      if apt-get remove --purge -y "$app"; then
        removed_any=true
        echo "  Removed: $app"
      else
        echo -e "${RED}  Warning: Failed to remove $app${NC}" >&2
      fi
    fi
  else
    echo "  Not installed: $app"
  fi
done

if $dry_run; then
  echo "Dry run complete. No changes made."
else
  if $removed_any; then
    echo "Running autoremove to clean dependencies..."
  apt-get autoremove -y || echo -e "${RED}Warning: autoremove encountered an issue${NC}" >&2
  fi
  echo "Done." 
fi