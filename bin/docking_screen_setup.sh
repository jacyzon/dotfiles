#!/bin/sh
xrandr --output LVDS1 --off
sleep 0.2
xrandr --output VIRTUAL1 --off --output DP3 --off --output DP2 --off --output DP1 --off --output HDMI1 --off
sleep 0.2
xrandr --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
sleep 0.2
xrandr --output HDMI3 --mode 1920x1200 --pos 1920x0 --rotate left --output HDMI2 --mode 1920x1200 --pos 3120x0 --rotate left
