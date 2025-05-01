#!/usr/bin/env bash

print_help() {
  echo './deploy.sh [-y|--noconfirm|-h|--help] <manifest_file> [target_dir]'
  echo '    -h / --help      : show this message'
  echo '    -y / --noconfirm : skip all [y/N] questions'
  echo '    manifest_file    : location of the manifest file'
  echo '    target_dir       : link target location (default: $XDG_CONFIG_HOME or $HOME/.config)'
}

err() {
  echo -en "[\033[31mERROR\033[0m] $1\n"
  exit 1
}

warn() {
  echo -en "[\033[33mWARNING\033[0m] $1\n"
}

info() {
  echo -en "[\033[32mINFO\033[0m] $1\n"
}

setup_tgt() {
  if [ -d "$1" ]; then
    if [ -z "$(file "$1" | grep "link")" ]; then
      info "moved $1 => $1.old"
      rm -r "$1.old"
      mv "$1" "$1.old"
    else
      if [ "$NOCONFIRM" -eq 0 ]; then
        echo -en "Remove link to $1? [y/N] "
        read confirm
      else
        confirm="Y"
      fi
      if [[ "$confirm" == +(y|Y) ]]; then
        rm "$1"
      fi
    fi
  fi
}

SCRIPT_DIR="$(realpath $0 | xargs dirname)"
if [ -z "$XDG_CONFIG_HOME" ]; then
  TARGET_DIR="$HOME/.config"
else
  TARGET_DIR="$XDG_CONFIG_HOME"
fi
NOCONFIRM=0

if [ $# -eq 0 ]; then
  print_help
  exit 1
fi

while [ $# -gt 0 ] && [[ $1 == +(-)* ]]; do
  case "$1" in
    "-h"|"--help")
      print_help
      exit 0
      ;;
    "-y"|"--noconfirm")
      NOCONFIRM=1
      ;;
  esac
  shift
done

if [ -z "$1" ]; then
  err "No input manifest detected."
fi

if [ ! -f "$1" ]; then
  err "Manifest file \"$1\" not found."
else
  MANIFEST=$(cat $1)
fi

if [ -d "$2" ]; then
  if [ "$NOCONFIRM" -eq 0 ]; then
    echo -en "Deploy to $2? [y/N] "
    read confirm
  else
    confirm="Y"
  fi
  if [[ "$confirm" == +(y|Y) ]]; then
    TARGET_DIR="$2"
  fi
fi

for i in $MANIFEST; do
  if [ -n "$(echo "$i" | xargs | grep -E "^#")" ]; then
    continue
  fi
  mode=$(echo "$i" | awk -F'|' '{print $1}')
  dir=$(echo "$i" | awk -F'|' '{print $2}')
  src="$SCRIPT_DIR/$dir"
  tgt="$TARGET_DIR/$dir"

  if [ ! -d "$src" ]; then
    warn "$src is not a valid dir..."
    continue
  fi

  case $mode in
    c)
      mkdir $tgt &> /dev/null
      for j in $(ls $src); do
        skip=0
        if [ -f "$src/.gitignore" ]; then
          for k in $(cat "$src/.gitignore"); do
            if [[ $j == $k ]]; then
              skip=1
              break
            fi
          done
        fi
        if [ "$skip" -eq 1 ] || [ "$j" = ".gitignore" ]; then
          continue
        fi

        setup_tgt "$tgt/$j"
        info "linking $src/$j to $tgt/$j"
        ln -sf "$src/$j" "$tgt/$j"
      done
      ;;
    d)
      setup_tgt $tgt
      info "linking $src to $tgt"
      ln -sf $src $tgt
      ;;
    *)
      err "First column of the manifest should be either 'c' or 'd'"
  esac
done
