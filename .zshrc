[[ -d $HOME/.dotfiles ]] && alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
[[ -x $(command -v bat > /dev/null 2>&1) ]] && alias cat=bat
[[ -x $(command -v eza > /dev/null 2>&1) ]] && alias ls=eza
[[ -x $(command -v trash > /dev/null 2>&1) ]] && alias rm="trash -vF"
[[ -x $(command -v delta > /dev/null 2>&1) ]] && alias diff=delta
alias l="ls -A --color=always"

if [[ -x $(command -v bat > /dev/null 2>&1) ]]; then export MANPAGER="sh -c 'col -bx | bat -l man -p'" ; fi
export PS1="%F{blue}%1~%f%F{green} λ%f "
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
