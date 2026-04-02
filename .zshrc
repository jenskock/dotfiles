# Oh-My-Posh
eval "$(oh-my-posh init zsh --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/huvix.omp.json')"

# Ranger and rcd alias
ranger_cd() {
  local tmpfile
  tmpfile=$(mktemp)
  ranger --choosedir="$tmpfile" "$@"
  if [ -f "$tmpfile" ] && dir=$(cat "$tmpfile") && [ -d "$dir" ]; then
    cd "$dir"
  fi
  rm -f "$tmpfile"
}

alias rcd=ranger_cd

# ls alias
alias ll='ls -la'

# Add ~/.local/bin to PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Clean up merged git branches (CIA one-liner)
alias gitclean='git branch --merged origin/main | grep -vE "^\s*(\*|main|develop)" | xargs -n 1 git branch -d'

# Set terminal to 256 colors
export TERM=xterm-256color