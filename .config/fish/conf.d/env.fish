set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

if test -x (which nvim)
  set -gx SHELL (which nvim)
else if test -x (which vim)
  set -gx SHELL (which vim)
else
  set -gx SHELL /usr/bin/vi
end
