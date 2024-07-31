#!/bin/bash

set_wallpaper() {
    monitor="eDP-1"
    wallpaper_dir="$HOME/Pictures/bg"
    workspace_file="$HOME/.config/hypr/workspace_wallpapers"
    last_workspace_file="$HOME/.config/hypr/last_workspace"
    
    current_workspace=$(hyprctl monitors | grep "active workspace" | awk '{print $3}')
    
    # Ensure the workspace_file exists
    [ ! -f "$workspace_file" ] && touch "$workspace_file"
    
    # Read the last active workspace
    last_workspace=$(cat "$last_workspace_file" 2>/dev/null)
    
    # Only set wallpaper if the workspace has changed
    if [ "$current_workspace" != "$last_workspace" ]; then
        assigned_wallpaper=$(grep "^$current_workspace=" "$workspace_file" | cut -d'=' -f2)
        
        if [ -z "$assigned_wallpaper" ]; then
            used_wallpapers=$(awk -F '=' '{print $2}' "$workspace_file")
            files=($wallpaper_dir/*)
            
            # Filter out already used wallpapers
            available_files=()
            for file in "${files[@]}"; do
                if ! grep -q "$file" <<< "$used_wallpapers"; then
                    available_files+=("$file")
                fi
            done
            
            # If all wallpapers are used, reset the workspace_file
            if [ ${#available_files[@]} -eq 0 ]; then
                > "$workspace_file"
                available_files=("${files[@]}")
            fi
            
            random_file="${available_files[RANDOM % ${#available_files[@]}]}"
            echo "$current_workspace=$random_file" >> "$workspace_file"
        else
            random_file="$assigned_wallpaper"
        fi
        
        hyprctl hyprpaper wallpaper "$monitor,$random_file"
        echo "$current_workspace" > "$last_workspace_file"
    fi
}

set_wallpaper
