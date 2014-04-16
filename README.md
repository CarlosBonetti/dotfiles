# My dotfiles

Just a bunch of configuration files and scripts to install them on my `~/`, so I can feel home on every computer.

## Structure

Files are grouped in "topics" (e.g. git, javascript, bash etc). Each topic is just a folder that contains the respective configuration files.

## Bootstrapping and autoloading

What `bootstrap.sh` does:

* Creates a symbolic link of every `*.ln` file to `~/` (removing the .ln extension)
* Creates a symbolic link of every `*.bin` file to `~/bin/` (removing the .bin extension)
* Executes every `*.setup` file

What `.bashrc` does:

* Executes every `*.load` file, so they are loaded in your environment

## Inspiration

Main idea and some scritps were taken from [@holman dotfiles](https://github.com/holman/dotfiles). Thanks!
