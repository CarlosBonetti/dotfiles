#!/usr/bin/env bash

# Based on https://github.com/holman/dotfiles/blob/master/script/bootstrap

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OVERWRITE_ALL=false
SKIP_ALL=false

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

warning() {
  printf "\r\033[2K  [ \033[00;33m!!\033[0m ] \033[00;33m$1\033[0m\n"
}

ask() {
  printf "\r  [ \033[0;34m??\033[0m ] $1 "
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

# Creates a symbolic link between $1 and $2, asking for what to do if destiny already exists
#   $1 -> source, $2 -> destiny
#   Paths must be absolute
link() {
  src=`readlink -f "$1"`
  dest=$2
  skip=false
  overwrite=false

  if [ ! -f "$src" ]; then
    warning "(skipped) Not a file: ${src}"
    return
  fi

  if [ -f "$dest" ] || [ -d "$dest" ]; then
    if [ "$OVERWRITE_ALL" == "false" ] && [ "$SKIP_ALL" == "false" ]; then
      warning "File already exists: ${dest}"
      ask "What do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all:"
      read -n 1 action

      case "$action" in
        o )
          overwrite=true;;
        O )
          OVERWRITE_ALL=true;;
        s )
          skip=true;;
        S )
          SKIP_ALL=true;;
        * )
          skip=true;;
      esac
    fi

    if [ "$overwrite" == "true" ] || [ "$OVERWRITE_ALL" == "true" ]; then
      rm -rf "$dest"
    fi

    if [ "$skip" == "false" ] && [ "$SKIP_ALL" == "false" ]; then
      ln -s "$src" "$dest" || { fail "Something went wrong"; exit; }
      success "(overwrite) Created symbolic link ${dest} -> ${src}"
    else
      success "Skipped $src"
    fi
  else
    ln -s "$src" "$dest" || { fail "Something went wrong"; exit; }
    success "Created symbolic link ${dest} -> ${src}"
  fi
}

create_symlinks() {
  echo 'Creating symbolic links...'

  overwrite_all=false
  skip_all=false

  for source in `find $DOTFILES_ROOT -name *.ln`; do
    basename=`basename ${source} .ln`
    dest="$HOME/${basename}"

    link $source $dest
  done
}

create_symlinks
