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

# Clean up stale local branches whose upstream was deleted
gitclean() {
  git fetch --prune || return 1

  git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads \
    | awk '$2 == "[gone]" { print $1 }' \
    | grep -vE '^(main|develop)$' \
    | while IFS= read -r branch; do
        [ -n "$branch" ] && git branch -D "$branch"
      done
}

# Set terminal to 256 colors
export TERM=xterm-256color