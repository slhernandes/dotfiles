#!/usr/bin/env bash
print_help() {
  echo './deploy.sh [-y|--noconfirm|-h|--help|-r|--replace|-u|--update] <manifest_file> [target_dir]'
  echo '    -h / --help      : show this message'
  echo '    -r / --replace   : do not skip when config exists in target_dir'
  echo '    -y / --noconfirm : skip all [y/N] questions'
  echo '    -u / --update    : Sync the plugins'
  echo '    manifest_file    : location of the manifest file'
  echo '    target_dir       : link target location (default: $XDG_CONFIG_HOME or $HOME/.config)'
}

err() {
  echo -en "[\033[31mERROR\033[0m] $1\n"
  exit 1
}

info() {
  echo -en "[\033[32mINFO\033[0m] $1\n"
}

warn() {
  echo -en "[\033[33mWARNING\033[0m] $1\n"
}

prompt() {
  echo -en "[\033[34mPROMPT\033[0m] $1 "
}

setup_tgt() {
  if [ -e "$1" ]; then
    if [ -z "$(file "$1" | grep "link")" ]; then
      confirm="N"
      bn=$(echo $1 | xargs basename)
      if [ "$NOCONFIRM" -eq 0 ]; then
        prompt "move $bn to ${bn}.old? [y/N]"
        read confirm
      else
        confirm="Y"
      fi
      if [[ "$confirm" == +(y|Y) ]]; then
        info "moved $bn => ${bn}.old"
        rm -rf "$1.old"
        mv "$1" "$1.old"
      fi
    else
      confirm="N"
      if [ "$NOCONFIRM" -eq 0 ]; then
        prompt "Remove link to $1? [y/N]"
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
NOCONFIRM=0
REPLACE=0
UPDATE=0
if [ -z "$XDG_CONFIG_HOME" ]; then
  TARGET_DIR="$HOME/.config"
else
  TARGET_DIR="$XDG_CONFIG_HOME"
fi

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
    "-r"|"--replace")
      REPLACE=1
      ;;
    "-u"|"--update")
      UPDATE=1
      ;;
  esac
  shift
done
if [ "$REPLACE" -eq 0 ]; then
  warn "\033[31mexisting config will be skipped. Use -r flag to overwrite the existing config\033[0m"
fi
if [ -z "$1" ]; then
  err "No input manifest detected."
fi
if [ ! -f "$1" ]; then
  err "Manifest file \"$1\" not found."
else
  MANIFEST=$(cat $1)
fi
if [ -n "$2" ] && [ -d "$2" ]; then
  confirm="N"
  if [ "$NOCONFIRM" -eq 0 ]; then
    prompt "Deploy to $2? [y/N]"
    read confirm
  else
    confirm="Y"
  fi
  if [[ "$confirm" == +(y|Y) ]]; then
    TARGET_DIR=$(realpath "$2")
  else
    info "cancelled config deployment to $2"
    exit 0
  fi
elif [ -n "$2" ]; then
  err "$2 is not a existing directory."
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
      if [ -f "$src/.plugins" ]; then
        for j in $(cat "$src/.plugins"); do
          plugin_dir=$(echo $j | awk -F'|' '{print $1}')
          giturl=$(echo $j | awk -F'|' '{print $2}')
          if [ "$UPDATE" -eq 1 ] || [ ! -d "$tgt/$plugin_dir" ]; then
            if [ -d "$tgt/$plugin_dir" ] && [ -n "$tgt" ]; then
              rm -rf "$tgt/$plugin_dir"
            fi
            git clone --depth=1 --recursive $giturl "$tgt/$plugin_dir"
          elif [ "$UPDATE" -eq 0 ] && [ -d "$tgt/$plugin_dir" ]; then
            info "skipping update $dir"
          fi
        done
      fi
      if [ "$REPLACE" -eq 0 ] && [ -d "$tgt" ]; then
        continue
      fi
      if [ -n "$(file "$tgt" | grep "link")" ]; then
        rm "$tgt"
      fi
      if [ ! -d "$tgt" ]; then
        mkdir "$tgt"
      fi
      for j in $(ls -A $src); do
        skip=0
        if [ -f "$src/.gitignore" ]; then
          for k in $(cat "$src/.gitignore"); do
            if [[ $j == $k ]]; then
              skip=1
              break
            fi
          done
        fi
        if [ "$skip" -eq 1 ] || [ "$j" = ".gitignore" ] || [ "$j" = ".plugins" ]; then
          continue
        fi
        setup_tgt "$tgt/$j"
        if [ ! -e "$tgt/$j" ]; then
          info "linking $src/$j to $tgt/$j"
          ln -sf "$src/$j" "$tgt/$j"
        else
          info "skipping $j"
        fi
      done
      ;;
    d)
      if [ "$REPLACE" -eq 0 ] && [ -d "$tgt" ]; then
        info "skipping $dir"
        continue
      fi
      setup_tgt $tgt
      if [ -d "$tgt" ]; then
        info "skipping $dir"
        continue
      fi
      info "linking $src to $tgt"
      ln -sf $src $tgt
      ;;
    cp)
      if [ "$REPLACE" -eq 0 ] && [ -d "$tgt" ]; then
        info "skipping $dir"
        continue
      fi
      setup_tgt $tgt
      if [ -d "$tgt" ]; then
        info "skipping $dir"
        continue
      fi
      info "copying $src to $tgt"
      cp -r $src $tgt
      if [ -f "$src/.plugins" ]; then
        for j in $(cat "$src/.plugins"); do
          plugin_dir=$(echo $j | awk -F'|' '{print $1}')
          giturl=$(echo $j | awk -F'|' '{print $2}')
          if [ "$UPDATE" -eq 1 ] || [ ! -d "$tgt/$plugin_dir" ]; then
            if [ -d "$tgt/$plugin_dir" ] && [ -n "$tgt" ]; then
              rm -rf "$tgt/$plugin_dir"
            fi
            git clone --depth=1 --recursive $giturl "$tgt/$plugin_dir"
          elif [ "$UPDATE" -eq 0 ] && [ -d "$tgt/$plugin_dir" ]; then
            info "skipping update $dir"
          fi
        done
      fi
      ;;
    *)
      err "First column of the manifest should be either 'c' or 'd' or 'cp'"
      ;;
  esac
done
