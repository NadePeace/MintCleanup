#!/bin/bash

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

# Uninstall the applications
for app in "${applications[@]}"; do
  echo "Uninstalling $app..."
  sudo apt-get remove --purge -y "$app"
  sudo apt-get autoremove -y
  echo "$app has been uninstalled."
done

echo "All applications have been uninstalled."