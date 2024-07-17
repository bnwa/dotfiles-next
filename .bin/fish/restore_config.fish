#!/usr/bin/env fish
if not test -d "$XDG_DATA_HOME"/nvim.bak
    or not test -d "$XDG_STATE_HOME"/nvim.bak
    or not test -d "$XDG_CACHE_HOME"/nvim.bak
        echo "Failed query for requisite directories"
    return 1
end
rm -rf "$XDG_DATA_HOME"/nvim
mv "$XDG_DATA_HOME"/nvim{.bak,}
rm -rf "$XDG_STATE_HOME"/nvim
mv "$XDG_STATE_HOME"/nvim{.bak,}
rm -rf "$XDG_CACHE_HOME"/nvim
mv "$XDG_CACHE_HOME"/nvim{.bak,}
