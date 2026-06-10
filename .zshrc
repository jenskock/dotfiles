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

# Docker disk cleanup (truncate logs + system prune)
docker-cleanup() {
  sudo bash -euo pipefail <<'EOF'
echo "=== Docker disk before ==="
df -h /var/lib/docker 2>/dev/null || df -h /
echo
echo "=== Truncating container logs ==="
find /var/lib/docker/containers -name "*-json.log" -print -exec truncate -s 0 {} \;
echo
echo "=== Docker system prune ==="
docker system prune -af
echo
echo "=== Docker disk after ==="
df -h /var/lib/docker 2>/dev/null || df -h /
echo
echo "Done."
EOF
}

# Set terminal to 256 colors
export TERM=xterm-256color