#!/usr/bin/env bash

# 使用 /dev/shm (共享記憶體) 替代 /tmp，減少物理磁碟 I/O，這對 NixOS + SSD 很友善
STATE_DIR="/dev/shm/pomodoro"
mkdir -p "$STATE_DIR"

STATE_FILE="$STATE_DIR/state"     # idle, running, paused
TIME_FILE="$STATE_DIR/time"       # seconds left
STATUS_FILE="$STATE_DIR/status"   # Work, Break

WORK_TIME=$((25 * 60))
BREAK_TIME=$((5 * 60))

# 初始化 (使用 [[ 指令更現代且快速)
[[ ! -f "$STATE_FILE" ]] && echo "idle" > "$STATE_FILE"
[[ ! -f "$TIME_FILE" ]]  && echo "$WORK_TIME" > "$TIME_FILE"
[[ ! -f "$STATUS_FILE" ]] && echo "Work" > "$STATUS_FILE"

# --- 指令處理 ---

start()  { echo "running" > "$STATE_FILE"; }
pause()  { echo "paused" > "$STATE_FILE"; }
reset()  {
    echo "idle" > "$STATE_FILE"
    echo "$WORK_TIME" > "$TIME_FILE"
    echo "Work" > "$STATUS_FILE"
}
toggle() {
    [[ $(< "$STATE_FILE") == "running" ]] && pause || start
}

# --- 核心 Listen 邏輯 ---

listen() {
    # 預載入狀態到變數，減少迴圈內的 cat 次數
    local last_state=""
    local last_time=""
    local last_status=""

    while true; do
        # 1. 讀取當前狀態 (使用 $(< file) 比 cat 快，因為是 Bash 內建)
        local state=$(< "$STATE_FILE")
        local time_left=$(< "$TIME_FILE")
        local status=$(< "$STATUS_FILE")

        # 2. 邏輯更新
        if [[ "$state" == "running" ]]; then
            if (( time_left > 0 )); then
                (( time_left-- ))
                echo "$time_left" > "$TIME_FILE"
            else
                echo "paused" > "$STATE_FILE"
                if [[ "$status" == "Work" ]]; then
                    status="Break"
                    time_left=$BREAK_TIME
                    notify-send -u critical "Pomodoro" "Work ended! Click to start break. ☕"
                else
                    status="Work"
                    time_left=$WORK_TIME
                    notify-send -u normal "Pomodoro" "Break ended! Click to start work. 🚀"
                fi
                echo "$status" > "$STATUS_FILE"
                echo "$time_left" > "$TIME_FILE"
            fi
        fi

        # 3. 格式化輸出
        local min=$((time_left / 60))
        local sec=$((time_left % 60))
        local time_display=$(printf "%02d:%02d" $min $sec)
        
        # 根據狀態決定顯示文字
        local status_display="$status"
        [[ "$state" == "idle" ]] && status_display="Pomodoro"
        # 移除暫停時顯示 "Paused" 的邏輯，讓它顯示即將開始的 Work/Break 狀態

        # 4. 輸出 JSON 給 Eww (只有在內容變動時才輸出，進一步省效能)
        # 但番茄鐘每秒都在變，所以這裡直接 print
        printf '{"time":"%s","status":"%s","state":"%s"}\n' \
            "$time_display" "$status_display" "$state"
            
        sleep 1
    done
}

case "$1" in
    toggle) toggle ;;
    reset)  reset ;;
    listen) listen ;;
    *)      listen ;; # 預設進入監聽模式
esac
