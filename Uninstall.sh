#!/bin/bash

# List of applications to uninstall
applications=(
  "thunderbird"
  "python3-uno"
  "gnome-todo"
  "rhythmbox"
  "gnome-calendar"
  "gnome-mines"
  "gnome-sudoku"
  "gnome-mahjongg"
  "gnome-todo-common"
  "gnome-video-effects"
  "transmission-gtk"
)

# Uninstall the applications
for app in "${applications[@]}"; do
  echo "Uninstalling $app..."
  sudo apt-get remove --purge -y "$app"
  sudo apt-get autoremove -y
  echo "$app has been uninstalled."
done

echo "All applications have been uninstalled."