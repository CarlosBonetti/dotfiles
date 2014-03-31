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

info() {
  printf "\r\033[2K  [ \033[00;34m..\033[0m ] \033[00;34m$1\033[0m\n"
}

ask() {
  printf "\r  [ \033[0;34m??\033[0m ] $1 "
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

header() {
  echo ''
  printf "\033[00;4m$1\033[0m\n"
}

subheader() {
  echo ''
  printf "\r  \033[00;1m$1\033[0m\n"
}

# (try to) create a symbolic link between $1 and $2, exiting script if fails
_slink() {
  ln -s "$1" "$2" || { fail "Something went wrong"; exit; }
}

# Creates a symbolic link between $1 and $2, asking for what to do if:
#   - destiny already exists (overwrite or skip)
#   - destiny's dirname does not exist (create dir or skip)
link() {
  src=`readlink -f "$1"`
  dest=$2
  skip=false
  overwrite=false

  if [ ! -f "$src" ]; then
    warning "(skipped) Not a file: ${src}"
    return
  fi

  dirname=`dirname "$dest"`
  if [ ! -d "$dirname" ]; then
    warning "Directory $dirname does not exist"
    ask "What do you want to do? [s]kip, [c]reate dir"
    read -n 1 action

    if [ "$action" == "c" ]; then
      mkdir -p "$dirname"
      success "Directory created: $dirname"
    else
      success "Skipped $src"
      return
    fi
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
      _slink "$src" "$dest"
      success "(overwrite) Created symbolic link ${dest} -> ${src}"
    else
      success "Skipped $src"
    fi
  else
    _slink "$src" "$dest"
    success "Created symbolic link ${dest} -> ${src}"
  fi
}

# Creates a symbolic link of every `*.ln` file in `~/`
create_symlinks() {
  header 'Linking *.ln files to ~/'

  for source in `find $DOTFILES_ROOT -name *.ln`; do
    basename=`basename ${source} .ln`
    dest="$HOME/${basename}"

    link $source $dest
  done
}

# Creates a symbolic link of every `*.bin` file in `~/bin/`
link_bin_files() {
  header 'Linking *.bin files to ~/bin/'

  for src in `find $DOTFILES_ROOT -name *.bin`; do
    basename=`basename ${src} .bin`
    dest="$HOME/bin/${basename}"

    link $src $dest
  done
}

# Executes every `*.setup` file
#   The current path is changed to the .setup path that is being executed
run_setups() {
  header 'Running *.setup files'

  for setup_file in `find $DOTFILES_ROOT -name *.setup`; do
    cd `dirname $setup_file`
    subheader "Running ${setup_file}"
    source $setup_file
  done

  cd $DOTFILES_ROOT
}

create_symlinks
link_bin_files
run_setups

success 'All done!'
