set -gx EDITOR nvim
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_INSTALL_UPGRADE 1
set -gx LANG en_US.UTF-8
test -x /opt/homebrew/bin/fish && set -gx SHELL /opt/homebrew/bin/fish
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
## Mason fucks up includes for native Python C extensions
test (xcode-select -p) && set -gx C_INCLUDE_PATH (xcode-select -p)/SDKs/MacOSX.sdk/usr/include/c++/v1
test (xcode-select -p) && set -gx CPLUS_INCLUDE_PATH (xcode-select -p)/SDKs/MacOSX.sdk/usr/include/c++/v1
