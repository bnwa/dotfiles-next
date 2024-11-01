if status is-interactive
    # Commands to run in interactive sessions can go here
    test -x (which eza); and function ls; eza $argv; end
    test -x (which eza); and function l;
      eza --icons --group-directories-first $argv
    end
    test -x (which eza); and function ll;
      eza --icons --long --git --git-repos --group-directories-first $argv
    end
end
