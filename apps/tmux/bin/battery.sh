# heavily taken and adapted from https://github.com/richoH/dotfiles/blob/master/bin/battery

HEART_FULL="♥"
HEART_EMPTY="♡"


output_perc() {
    if [[ `uname` == 'Linux' ]]; then
        battery_status=$(__battery_linux)
    else
        battery_status=$(__battery_osx)
    fi

    if [ -n "$battery_status" ]; then
        echo "${battery_status}%"
    fi
}

__battery_osx() {
    ioreg -c AppleSmartBattery -w0 | \
        grep -o '"[^"]*" = [^ ]*' | \
        sed -e 's/= //g' -e 's/"//g' | \
        sort | \
        while read key value; do
            case $key in
                "MaxCapacity")
                    export maxcap=$value;;
                "CurrentCapacity")
                    export curcap=$value;;
                "ExternalConnected")
                    export extconnect=$value;;
                "FullyCharged")
                    export fully_charged=$value;;
            esac

            if [[ -n $maxcap && -n $curcap && -n $extconnect ]]; then
                if [[ "$curcap" == "$maxcap" || "$fully_charged" == "Yes" && $extconnect == "Yes"  ]]; then
                    return
                fi
                charge=$(( 100 * $curcap / $maxcap ))
                if [[ $charge -lt 20 ]]; then
                    echo "#[fg=red] ${HEART_EMPTY} $charge"
                else
                    echo "#[fg=yellow] ${HEART_FULL} $charge"
                fi
                break
            fi
        done
}

__battery_linux() {
    case "$SHELL_PLATFORM" in
        "linux")
            BATPATH=/sys/class/power_supply/BAT0
            if [ ! -d $BATPATH ]; then
                BATPATH=/sys/class/power_supply/BAT1
            fi
            STATUS=$BATPATH/status
            BAT_FULL=$BATPATH/charge_full
            if [ ! -r $BAT_FULL ]; then
                BAT_FULL=$BATPATH/energy_full
            fi
            BAT_NOW=$BATPATH/charge_now
            if [ ! -r $BAT_NOW ]; then
                BAT_NOW=$BATPATH/energy_now
            fi

            if [ "$1" = `cat $STATUS` -o "$1" = "" ]; then
                __linux_get_bat
            fi
            ;;
        "bsd")
            STATUS=`sysctl -n hw.acpi.battery.state`
            case $1 in
                "Discharging")
                    if [ $STATUS -eq 1 ]; then
                        __freebsd_get_bat
                    fi
                ;;
            "Charging")
                if [ $STATUS -eq 2 ]; then
                    __freebsd_get_bat
                fi
                ;;
            "")
                __freebsd_get_bat
                ;;
            esac
        ;;
    esac
}


__linux_get_bat() {
    bf=$(cat $BAT_FULL)
    bn=$(cat $BAT_NOW)
    echo $(( 100 * $bn / $bf ))
}

__freebsd_get_bat() {
    echo "$(sysctl -n hw.acpi.battery.life)"
}


output_perc
