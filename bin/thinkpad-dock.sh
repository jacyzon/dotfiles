#!/bin/sh -e

# Save this file as /etc/sbin/thinkpad-dock.sh

# wait for the dock state to change
sleep 1

if [[ "$ACTION" == "add" ]]; then
  DOCKED=1
  logger -t DOCKING "Detected condition: docked"
elif [[ "$ACTION" == "remove" ]]; then
  DOCKED=0
  logger -t DOCKING "Detected condition: un-docked"
else
  logger -t DOCKING "Detected condition: unknown"
  echo Please set env var \$ACTION to 'add' or 'remove'
  exit 1
fi

# invoke from XSetup with NO_KDM_REBOOT otherwise you'll end up in a KDM reboot loop
NO_KDM_REBOOT=0
for p in $*; do
  case "$p" in
  "NO_KDM_REBOOT") NO_KDM_REBOOT=1 ;;
  "SWITCH_TO_LOCAL") DOCKED=0 ;;
  esac
done

function switch_to_local {
  export DISPLAY=$1
  logger -t DOCKING "Switching off HDMI3/VGA1 and switching on LVDS1"

  /usr/sbin/xrandr --output HDMI3 --off
  /usr/sbin/xrandr --output VGA1 --off
  /usr/sbin/xrandr --output LVDS1 --auto
}

function switch_to_external {
  export DISPLAY=$1
  logger -t DOCKING "Switching off LVDS1 and switching on HDMI3/VGA1"

  /usr/sbin/xrandr --output LVDS1 --off
  /usr/sbin/xrandr --output HDMI3 --auto --primary
  /usr/sbin/xrandr --output VGA1 --auto --right-of HDMI3
}

case "$DOCKED" in
  "0")
    #undocked event
    switch_to_local :0 ;;
  "1")
    #docked event
    switch_to_external :0 ;;
esac
