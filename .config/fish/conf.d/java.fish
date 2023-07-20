if test -r (pwd)/.java-version
    set -l java_version (cat .java-version)
    set -x JAVA_HOME (/usr/libexec/java_home -v $java_version)
else if test (/usr/libexec/java_home -V 2&> /dev/null)
    set -x JAVA_HOME (/usr/libexec/java_home -v 17)
end
