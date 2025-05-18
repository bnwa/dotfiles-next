function javah --argument-names java_version --description "List and set the Java environment version"
    if test -z $java_version
        set -l java_list (/usr/libexec/java_home -V 1> /dev/null)
        return 0
    end
    switch $java_version
    case 8
        test (/usr/libexec/java_home -F -v 1.8 2> /dev/null) && set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)
        return 0
    case 11
        test (/usr/libexec/java_home -F -v 11 2> /dev/null) && set -gx JAVA_HOME (/usr/libexec/java_home -v 11)
        return 0
    case 17
        test (/usr/libexec/java_home -F -v 17 2> /dev/null) && set -gx JAVA_HOME (/usr/libexec/java_home -v 17)
        return 0
    end
    echo "No matching JDK distribution"
    return 1
end
