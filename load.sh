# Generic load file
# Might be executed by any `*rc` file (`.bashrc`, `.zshrc`, ...)

# Includes user's private bin in PATH if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# Executes every `*.load` file inside the dotfiles structure
for file in $(find "$DOTFILES_HOME" -name "*.load"); do
  source "$file"
done

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# rvm
export PATH="$PATH:$HOME/.rvm/bin"

# sdkman
export SDKMAN_DIR="/home/bonetti/.sdkman"
[[ -s "/home/bonetti/.sdkman/bin/sdkman-init.sh" ]] && source "/home/bonetti/.sdkman/bin/sdkman-init.sh"
