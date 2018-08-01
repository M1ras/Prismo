#!/usr/bin/env bash

NAME='Prismo'
VERSION='0.0.0'

OPTION_HELP='h'
OPTION_VERSION='v'
OPTIONS="$OPTION_HELP$OPTION_VERSION"

DESCRIPTION_HELP='Help Description'
DESCRIPTION_VERSION='Version Description'

help() {
  /usr/bin/printf ' -%s\t%s\n' \
    "$OPTION_HELP" "$DESCRIPTION_HELP" \
    "$OPTION_VERSION" "$DESCRIPTION_VERSION"

  exit
}

version() {
  /usr/bin/printf '%s %s\n' "$NAME" "$VERSION"
  exit
}

exitIfNotRoot() {
  if [[ `id -u` != '0' ]]; then
    /usr/bin/printf '%s needs to be run as root. Exiting...\n' "$NAME"
    exit 13
  fi
}

while getopts "$OPTIONS" OPTION; do
  case "$OPTION" in
    "$OPTION_HELP")
      help
      ;;
    "$OPTION_VERSION")
      version
      ;;
  esac
done
