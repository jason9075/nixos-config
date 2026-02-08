# TOOLS.md

此檔案定義了 ClawBot 的能力。這些工具封裝了標準的 Linux 指令。

## Vision Tools (視覺工具)

### screenshot
擷取當前螢幕畫面以分析 UI 狀態。
- **Command**: `scrot -o /tmp/view.png && echo "/tmp/view.png"`
- **Description**: 回傳一張最新的截圖路徑。在點擊之前使用此功能來尋找座標。

## Navigation Tools (i3wm 導航工具)

### i3_switch
切換到特定的工作區 (Workspace)。
- **Command**: `i3-msg workspace number {{workspace_id}}`
- **Arguments**:
  - `workspace_id`: 工作區編號 (例如 1, 9)。

### i3_focus
透過類別名稱聚焦特定視窗。
- **Command**: `i3-msg '[class="{{window_class}}"] focus'`
- **Arguments**:
  - `window_class`: 應用程式類別名稱 (例如 "Google-chrome", "Line", "Slack")。

### i3_fullscreen
切換當前視窗的全螢幕狀態。
- **Command**: `i3-msg fullscreen toggle`
- **Description**: 用於在截圖前最大化視窗以獲得最佳清晰度，截圖後請再次執行以還原。

## Action Tools (Input 操作工具)

### mouse_click
在特定座標點擊。
- **Command**: `xdotool mousemove {{x}} {{y}} click 1`
- **Arguments**:
  - `x`: X 座標。
  - `y`: Y 座標。

### type_text
在當前聚焦的視窗中輸入文字。
- **Command**: `xdotool type --delay 50 "{{text}}"`
- **Arguments**:
  - `text`: 要輸入的字串。

### press_key
模擬按鍵。
- **Command**: `xdotool key {{key}}`
- **Arguments**:
  - `key`: 按鍵組合 (例如 "Return", "ctrl+c", "F5")。

## Reporting Tools (回報工具)

### telegram_report
透過 Telegram 發送狀態報告給使用者。
- **Command**: `openclaw telegram send --text "{{message}}"`
- **Arguments**:
  - `message`: 報告內容。

