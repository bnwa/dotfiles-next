[[ -d $HOME/.dotfiles ]] && alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
[[ -x $(command -v bat 2> /dev/null) ]] && alias cat=bat
[[ -x $(command -v eza 2> /dev/null) ]] && alias ls=eza
[[ -x $(command -v delta 2> /dev/null) ]] && alias diff=delta
[[ -x /opt/homebrew/bin/trash ]] && alias rm=trash -vF

[[ -x $(command -v eza 2> /dev/null) ]] && alias l=eza --icons --long --git --git-repos --group-directories-first

# Load environment variables from .secrets.env file if it exists
if [[ -f "$HOME/.secret.env" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Parse variable assignments (handle KEY=VALUE format)
    if [[ "$line" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
      local var_name="${match[1]}"
      local var_value="${match[2]}"

      # Remove surrounding quotes if present
      var_value="${var_value#\"}"
      var_value="${var_value%\"}"
      var_value="${var_value#\'}"
      var_value="${var_value%\'}"

      # Export the variable
      export "$var_name"="$var_value"
    fi
  done < "$HOME/.secret.env"
fi

if [[ -x $(command -v bat 2> /dev/null) ]]; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

export PS1="%F{blue}%1~%f%F{green} λ%f "
