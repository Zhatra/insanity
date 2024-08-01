#!/bin/bash

# Define the hour and minute when the reminder should start and end
START_HOUR=23
END_HOUR=3

# Path to the image for the notification
IMAGE_PATH="$HOME/Downloads/mikusleep.jpeg"

# Function to send a notification
send_notification() {
    notify-send -i "$IMAGE_PATH" "Hora de ir a dormir" "Es hora de prepararse para dormir."
}

# Infinite loop to check the time periodically
while true; do
    # Get the current hour and minute
    CURRENT_HOUR=$(date +'%H')
    CURRENT_MINUTE=$(date +'%M')

    # Check if the current time is within the reminder period
    if [ "$CURRENT_HOUR" -ge "$START_HOUR" ] || ([ "$CURRENT_HOUR" -ge 0 ] && [ "$CURRENT_HOUR" -lt "$END_HOUR" ]); then
        # Send the notification
        send_notification

        # Continue sending notifications every 15 minutes during the period
        while [ "$CURRENT_HOUR" -ge "$START_HOUR" ] || ([ "$CURRENT_HOUR" -ge 0 ] && [ "$CURRENT_HOUR" -lt "$END_HOUR" ]); do
            sleep 900 # 15 minutes in seconds

            # Get the updated hour and minute
            CURRENT_HOUR=$(date +'%H')
            CURRENT_MINUTE=$(date +'%M')

            # Send the notification
            send_notification
        done
    else
        # Sleep for an hour before checking again
        sleep 3600
    fi
done
