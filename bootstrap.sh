#!/usr/bin/env bash

# Based on https://github.com/holman/dotfiles/blob/master/script/bootstrap

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

warning() {
  printf "\r\033[2K  [ \033[00;33m!!\033[0m ] \033[00;33m$1\033[0m\n"
}

ask() {
  printf "\r  [ \033[0;33m??\033[0m ] $1 "
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

create_symlinks() {
  echo 'Creating symbolic links...'

  overwrite_all=false
  skip_all=false

  for source in `find $DOTFILES_ROOT -name *.ln`
  do
    basename=`basename ${source} .ln`
    dest="$HOME/${basename}"

    overwrite=false
    skip=false

    if [ -f $dest ] || [ -d $dest ]
    then

      if [ "$overwrite_all" == "false" ] && [ "$skip_all" == "false" ]
      then
        warning "File already exists: ${dest}"
        ask "What do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all:"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            skip=true;;
        esac
      fi

      if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
      then
        rm -rf $dest
      fi

      if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
      then
        ln -s $source $dest
        success "(overwrite) Created symbolic link ${dest} -> ${source}"
      else
        success "Skipped $source"
      fi

    else
      ln -s $source $dest
      success "Created symbolic link ${dest} -> ${source}"
    fi
  done
}

create_symlinks
