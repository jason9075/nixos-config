#!/usr/bin/env bash


# Define the Firefox process name
FIREFOX_PROCS=("firefox" "firefox-bin")

# Function to randomly select a URL from music_list.txt
get_random_url() {
    shuf -n 1 ~/music_list.txt
}

URL=$(get_random_url)

# Function to detect Firefox using multiple methods
detect_firefox() {
    for proc in "${FIREFOX_PROCS[@]}"; do
        if pgrep -x "$proc" > /dev/null; then
            echo "$proc process found using pgrep."
            return 0
        fi
    done

    if ps aux | grep -i '[f]irefox' | grep -v "grep" > /dev/null; then

        echo "Firefox process found using ps aux."
        return 0
    fi

    echo "Firefox is not running."
    return 1
}

# Function to kill all Firefox processes
kill_firefox() {
    echo "Closing all Firefox processes..."
    for proc in "${FIREFOX_PROCS[@]}"; do
        pgrep -x "$proc" | xargs -r kill
    done

    ps aux | awk '/[f]irefox/ {print $2}' | xargs -r kill
}

# Function to minimize Firefox window using wmctrl
minimize_firefox() {
    # Get the window ID for Firefox
    FIREFOX_WINDOW_ID=$(wmctrl -l | grep -i "Firefox" | awk '{print $1}')
    if [ -n "$FIREFOX_WINDOW_ID" ]; then
        wmctrl -i -r "$FIREFOX_WINDOW_ID" -b add,hidden
        echo "Firefox minimized."
    else
        echo "Could not find Firefox window to minimize."
    fi
}

# Main logic: check if Firefox is running
if detect_firefox; then
    kill_firefox
else
    # Start Firefox and minimize it using xdotool
    DISPLAY=:0
    firefox "$URL" -width 800 -height 600 & sleep 10 && xdotool search --name "Mozilla Firefox" windowminimize
    echo "Firefox started and minimized with URL: $URL"
fi

