#!/bin/sh
# Toggle ThinkPad wwan state

# --- Definitions
NTFY=notify-send
ICON=nm-device-wwan

# --- Functions
show_notification () { # $1: 0=off/1=on/254=none
    local title msg

    [ "$do_notify" = "1" ] || return 0
    
    if [ -n "$XAUTHORITY" ]; then 
        # build msg depending on language
        case "$LANGUAGE" in
            de*)
                title="Netzwerk"
                case "$1" in
                    1)   msg="WWAN: ein" ;;
                    0)   msg="WWAN: aus" ;;
                    254) msg="WWAN: nicht vorhanden" ;;
                esac
                ;;
            
            *)
                title="Network"
                case "$1" in
                    1)   msg="WWAN: on" ;;
                    0)   msg="WWAN: off" ;;
                    254) msg="WWAN: no device" ;;
                esac
                ;;
        esac
        
        # show msg
        $NTFY -i $ICON $title "$msg"
    fi
    
    return 0
}

# --- MAIN

# Check if acpi-support functions are available
if [ -f /usr/share/acpi-support/power-funcs ]; then
   . /usr/share/acpi-support/power-funcs

   # get DISPLAY & XAUTHORITY
   getXconsole
   do_notify=1
else
   do_notify=0
fi

# Get wwan state
wwan_state=$(rfkill list | sed -n -e '/Wireless WAN/,/^[0-9]/p')

if [ -z "$wwan_state" ]; then
    show_notification 254
else
    if [ -n "$(echo $wwan_state | grep 'Soft blocked: yes')" ]; then
        rfkill unblock wwan
        show_notification 1
    else
        rfkill block wwan
        show_notification 0
    fi
fi

exit 0
