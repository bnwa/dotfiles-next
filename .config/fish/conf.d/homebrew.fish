if test -d /opt/homebrew/bin; and test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
else if test -d /usr/local/bin; and test -x /usr/local/bin/brew
    eval "$(/usr/local/bin/brew shellenv)"
end
