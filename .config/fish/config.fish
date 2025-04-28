# Function to load environment variables from a file
function load_env_file --argument-names env_file
    if test -f $env_file
        while read -l line
            if string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' -- $line
                set -l name (string split -m 1 '=' $line)[1]
                set -l value (string split -m 1 '=' $line)[2]
                # Remove surrounding quotes if they exist
                set value (string trim -c '"' (string trim -c "'" $value))
                set -gx $name $value
            end
        end <$env_file
    end
end

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
    test -x "$(which bat)"; and function cat
        bat $argv
    end

    # Load secret environment variables
    test -f ~/.secret.env; and load_env_file ~/.secret.env

    fish_vi_key_bindings

    for mode in insert default visual
        bind -M $mode \cg forward-char
        # Ctrl+Shift+f for incremental accept
        bind -M $mode \ct forward-word
    end
end
