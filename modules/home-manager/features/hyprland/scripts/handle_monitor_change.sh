#!/bin/sh

LAPTOP_MONITOR="eDP-1"
EXTERNAL_MONITOR="DP-1"

handle() {
  case $1 in 
    monitoradded*)
      # Move special workspace to the laptop screen
      WINDOW_IDS=$(hyprctl clients | grep -F8 "special:special" | grep "pid" | awk '{print $2}')
      
      for WINDOW_ID in $WINDOW_IDS; do
        hyprctl dispatch movetoworkspace "2147483647,pid:$WINDOW_ID"
      done

      hyprctl dispatch moveworkspacetomonitor "2147483647 $LAPTOP_MONITOR" 
      
      # Move active workspaces to the external monitor
      ACTIVE_WORKSPACES=$(hyprctl workspaces | grep workspace | awk '$3 != "2147483647" {print $3}')

      for workspace in $ACTIVE_WORKSPACES; do
        hyprctl dispatch moveworkspacetomonitor "$workspace $EXTERNAL_MONITOR"
      done
    ;;
  
   monitorremoved*)
      # Move all windows from the special workspace back
      WINDOW_IDS=$(hyprctl clients | grep -F8 "2147483647" | grep "pid" | awk '{print $2}')
      
      for WINDOW_ID in $WINDOW_IDS; do
        hyprctl dispatch movetoworkspacesilent "special:special,pid:$WINDOW_ID"
      done
    ;;
  esac
}

# Listen to Hyprland's IPC socket for events
nc -U "$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do
  handle "$line"
done
