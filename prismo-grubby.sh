#!/usr/bin/env bash

NAME='Prismo'
VERSION='0.0.0'

OPTION_HELP='h'
OPTION_VERSION='v'
OPTION_LOAD_KERNEL='l'
OPTIONS="$OPTION_HELP$OPTION_VERSION$OPTION_LOAD_KERNEL"

DESCRIPTION_HELP='Help Description'
DESCRIPTION_VERSION='Version Description'

declare -A BOOT_ENTRIES
BOOT_ENTRIES_LAST_INDEX=-1

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

getBootEntries() {
  local LAST_INDEX=-1;
  local NON_LINUX_INDICES=0;

  while read -r LINE; do
    local INDEX=`/usr/bin/printf '%s\n' "$LINE" | sed -nE 's/^index=(.+)$/\1/p'`
    local KERNEL=`/usr/bin/printf '%s\n' "$LINE" | sed -nE 's/^kernel=(.+)$/\1/p'`
    local ARGS=`/usr/bin/printf '%s\n' "$LINE" | sed -nE 's/^args="(.+)"$/\1/p'`
    local ROOT=`/usr/bin/printf '%s\n' "$LINE" | sed -nE 's/^root=(.+)$/\1/p'`
    local INITRD=`/usr/bin/printf '%s\n' "$LINE" | sed -nE 's/^initrd=(.+)$/\1/p'`
    local TITLE=`/usr/bin/printf '%s\n' "$LINE" | sed -nE 's/^title=(.+)$/\1/p'`
    local NON_LINUX_ENTRY=`/usr/bin/printf '%s\n' "$LINE" | sed -nE 's/^(non linux entry)$/\1/p'`

    if [[ -n "$INDEX" ]]; then
      LAST_INDEX="$INDEX"
      BOOT_ENTRIES["$LAST_INDEX,INDEX"]="$INDEX"
    fi

    [[ -n "$KERNEL" ]] && BOOT_ENTRIES["$LAST_INDEX,KERNEL"]="$KERNEL"
    [[ -n "$ARGS" ]] && BOOT_ENTRIES["$LAST_INDEX,ARGS"]="$ARGS"
    [[ -n "$ROOT" ]] && BOOT_ENTRIES["$LAST_INDEX,ROOT"]="$ROOT"
    [[ -n "$INITRD" ]] && BOOT_ENTRIES["$LAST_INDEX,INITRD"]="$INITRD"
    [[ -n "$TITLE" ]] && BOOT_ENTRIES["$LAST_INDEX,TITLE"]="$TITLE"

    if [[ -n "$NON_LINUX_ENTRY" ]]; then
      let "NON_LINUX_INDICES=$NON_LINUX_INDICES + 1"
      unset BOOT_ENTRIES["$LAST_INDEX,INDEX"]
    fi
  done <<< `grubby --info=ALL`

  let "BOOT_ENTRIES_LAST_INDEX=LAST_INDEX - NON_LINUX_INDICES"
}

printBootEntries() {
  /usr/bin/printf ' %s \t %s \n' "INDEX" "KERNEL"

  local CURRENT_INDEX=0
  while [[ "$CURRENT_INDEX" -le "$BOOT_ENTRIES_LAST_INDEX" ]]; do
    /usr/bin/printf ' %s \t %s \n' "$CURRENT_INDEX" "${BOOT_ENTRIES[$CURRENT_INDEX,TITLE]}"
    let "CURRENT_INDEX=$CURRENT_INDEX + 1"
  done
}

while getopts "$OPTIONS" OPTION; do
  case "$OPTION" in
    "$OPTION_HELP")
      help
      ;;
    "$OPTION_VERSION")
      version
      ;;
    "$OPTION_LOAD_KERNEL")
      exitIfNotRoot
      getBootEntries
      printBootEntries
      ;;
  esac
done
