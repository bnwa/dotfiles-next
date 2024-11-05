if status is-interactive
    # NB. test behavior no worky with flag and possibly empty
    # value, must quote possibly empty value or test returns 0
    # See https://github.com/fish-shell/fish-shell/issues/2037
    test -x "$(which eza)"; and function ls
        eza $argv
    end
    test -x "$(which eza)"; and function l
        eza --icons --group-directories-first $argv
    end
    test -x "$(which eza)"; and function ll
        eza --icons --long --git --git-repos --group-directories-first $argv
    end

    fish_vi_key_bindings

    for mode in insert default visual
        bind -M $mode \cg forward-char
        # Ctrl+Shift+f for incremental accept
        bind -M $mode \ct forward-word
    end
end
