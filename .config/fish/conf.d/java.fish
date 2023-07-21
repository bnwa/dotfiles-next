# If any installed, poitn to JDK providing latest Java version
if test -n (/usr/libexec/java_home -V 2> /dev/null)
    set -x JAVA_HOME (/usr/libexec/java_home -V 2> /dev/null)
end
