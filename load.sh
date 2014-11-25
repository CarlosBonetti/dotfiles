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

# Add heroku toolbelt to the environment
if [ -d "/usr/local/heroku/bin" ] ; then
  PATH="/usr/local/heroku/bin:$PATH"
fi
