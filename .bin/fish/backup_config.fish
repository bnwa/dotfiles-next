#!/usr/bin/env fish
if test -d "$XDG_DATA_HOME"/nvim.bak
    or test -d "$XDG_STATE_HOME"/nvim.bak
    or test -d "$XDG_CACHE_HOME"/nvim.bak
        echo "Target backup directories exist, will not overwrite"
    return 1
end
if not test -d "$XDG_DATA_HOME"/nvim
    or not test -d "$XDG_STATE_HOME"/nvim
    or not test -d "$XDG_CACHE_HOME"/nvim
        echo "Expected source directory did not exist"
    return 1
end
mv "$XDG_DATA_HOME"/nvim{,.bak}
mv "$XDG_STATE_HOME"/nvim{,.bak}
mv "$XDG_CACHE_HOME"/nvim{,.bak}
