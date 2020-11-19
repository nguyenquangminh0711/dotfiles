#!/bin/bash
# Battery blocklet for Regolith
# This script was adapted from https://github.com/hastinbe/i3blocks-battery-plus

LABEL_COLOR=${label_color:-$(xrescat i3xrocks.label.color "#7B8394")}
VALUE_FONT=${font:-$(xrescat i3xrocks.value.font "Source Code Pro Medium 13")}
BUTTON=${button:-}

# Get battery status.
#
# Returns:
#   The battery's status or state.
get_battery_status() {
    echo "$__UPOWER_INFO" | awk -W posix '$1 == "state:" {print $2}'
}

# Get battery percentage.
#
# Returns:
#   The battery's percentage, without the %.
get_battery_percent() {
    echo "$__UPOWER_INFO" | awk -W posix '$1 == "percentage:" { gsub("%","",$2); print int($2)}'
}

BATT_DEVICE="DisplayDevice"
__UPOWER_INFO=$(upower --show-info "/org/freedesktop/UPower/devices/${BLOCK_INSTANCE:-$BATT_DEVICE}")


BATT_PERCENT=$(get_battery_percent)
CHARGE_STATE=$(get_battery_status)

if [ -z "$CHARGE_STATE" ]; then
    exit 0
fi

if [ -z "$BATT_PERCENT" ]; then
    exit 0
elif [ "$CHARGE_STATE" == "charging" ]; then
    LABEL_ICON=$(xrescat i3xrocks.label.batterycharging C)
    VALUE_COLOR=$(xrescat i3xrocks.label.color white)
elif [ "$BATT_PERCENT" -ge 0 ] && [ "$BATT_PERCENT" -le 20 ]; then
    LABEL_ICON=$(xrescat i3xrocks.label.battery0 E)
    VALUE_COLOR=$(xrescat i3xrocks.critical.color red)
elif [ "$BATT_PERCENT" -ge 20 ] && [ "$BATT_PERCENT" -le 50 ]; then
    LABEL_ICON=$(xrescat i3xrocks.label.battery20 L)
    VALUE_COLOR=$(xrescat i3xrocks.error.color orange)
elif [ "$BATT_PERCENT" -ge 50 ] && [ "$BATT_PERCENT" -le 80 ]; then
    LABEL_ICON=$(xrescat i3xrocks.label.battery50 M)
    VALUE_COLOR=$(xrescat i3xrocks.nominal white)
elif [ "$BATT_PERCENT" -ge 80 ] && [ "$BATT_PERCENT" -le 98 ]; then
    LABEL_ICON=$(xrescat i3xrocks.label.battery80 F)
    VALUE_COLOR=$(xrescat i3xrocks.label.color white)
else
    LABEL_ICON=$(xrescat i3xrocks.label.battery100 C)
    VALUE_COLOR=$(xrescat i3xrocks.label.color white)
fi

ICON_SPAN="<span color=\"${LABEL_COLOR}\">$LABEL_ICON</span>"
VALUE_SPAN="<span font_desc=\"${VALUE_FONT}\" color=\"${VALUE_COLOR}\"> $BATT_PERCENT%</span>"

echo "${ICON_SPAN}${VALUE_SPAN}"

if [[ "x${BUTTON}" == "x1" ]]; then
    ACTION=$(xrescat i3xrocks.action.battery "/usr/bin/gnome-control-center --class=floating_window power")
    /usr/bin/i3-msg -q exec "$ACTION"
fi
