#
# Function to display resource usage information: CPU load average, free memory, and disk usage.
#
function resourcesInfo() {
    echo -e -n "$Dim[Res-Info]"
    USED_SPACE=$(df -H / |  awk '{print $5 }' | sed -e /^Use/d | sed 's/%//' | cut -d "." -f 1)
    SPACE_VERBOSE=$(df -H / |  awk '{print $5 " "$3" of "$2}' | sed -e /^Use/d)
    # I want to perform arithmetic comparison, bash doesn't work with floating points, hence the 'cut' command.
    MEMORY=$(grep MemAvailable < /proc/meminfo | awk '{print $2/1024}' | cut -d "." -f 1)
    LOAD=$(awk '{print "~5 min=" $2}' < /proc/loadavg)

    echo -e -n "$ColorReset""➜ [$Bold$Dim Load Average$ColorReset$Normal$Yellow$Dim $LOAD $ColorReset "

    if [[ $MEMORY -lt 2048 ]] ; then
        echo -e -n "$ColorReset""➜ $Bold$Dim Free Memory$ColorReset$Normal $Red ◉ $MEMORY$ColorReset$Dim MiB $ColorReset "
    else
        echo -e -n "$ColorReset""➜ $Bold$Dim Free Memory$ColorReset$Normal $Green ◉ $MEMORY$ColorReset$Dim MiB $ColorReset "
    fi

    if [[ $USED_SPACE -gt 75 ]] ; then
        echo -e -n "$ColorReset""➜ $Bold$Dim Disk Usage$ColorReset$Normal $Red ◉ $SPACE_VERBOSE $ColorReset]"
    else
        echo -e -n "$ColorReset""➜ $Bold$Dim Disk Usage$ColorReset$Normal $Green ◉ $SPACE_VERBOSE $ColorReset]"
    fi
}
