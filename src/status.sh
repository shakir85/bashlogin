# 
# Function to display the status of a given service using systemctl.
#
function serviceStatus () {
    IS_ACTIVE=$(systemctl is-active "$1")
    IS_UP=$(systemctl show -p SubState --value "$1")
    if [ "$IS_ACTIVE" = "active" ] ; then
    echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Green ✓$ColorReset$Dim active "

        case $IS_UP in
            "running") echo -e -n "$Green▲$ColorReset$Dim up$Normal$ColorReset ]" ;;
            "dead") echo -e -n "$Red▼$ColorReset$Dim down$ColorReset ]" ;;
            *) echo -e -n "Error loading service" ;;
        esac

    elif [ "$IS_ACTIVE" = "inactive" ] ; then
        echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Red ✗ $ColorReset inactive ] "

    else
        echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Yellow ● $ColorReset no status! ] "
    fi
}