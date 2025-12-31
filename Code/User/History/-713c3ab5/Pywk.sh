#!/bin/bash

# Waybar auto-restart script for Hyprland
# Watches waybar config files and restarts on changes

CONFIG_DIR="$HOME/.config/waybar"
CONFIG_FILE="$CONFIG_DIR/config"
STYLE_FILE="$CONFIG_DIR/style.css"

# Kill any existing waybar instances
killall waybar 2>/dev/null

# Start waybar
waybar &
WAYBAR_PID=$!

echo "Waybar started (PID: $WAYBAR_PID)"
echo "Watching for changes in: $CONFIG_DIR"

# Watch for file changes using inotifywait
inotifywait -m -e modify,create,delete,move "$CONFIG_DIR" | while read -r directory event filename; do
    # Only react to config and style.css changes
    if [[ "$filename" == "config" ]] || [[ "$filename" == "style.css" ]] || [[ "$filename" == "config.jsonc" ]]; then
        echo "Detected change in $filename, restarting waybar..."
        
        # Kill current waybar
        killall waybar 2>/dev/null
        sleep 0.5
        
        # Restart waybar
        waybar &
        WAYBAR_PID=$!
        
        echo "Waybar restarted (PID: $WAYBAR_PID)"
    fi
done