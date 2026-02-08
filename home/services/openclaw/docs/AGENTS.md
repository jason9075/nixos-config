# AGENTS.md — OpenClaw Workspace

## Agent: visual-operator
此 Agent 專門負責視覺化的桌面自動化操作。它被設計為一個通用的操作員，能夠學習並使用可用的技能來執行各種桌面任務。

### Trigger
- "檢查 *" (例如 "檢查 LINE", "檢查 Email")
- "看看螢幕"
- "自動化這個"
- "我的桌面上發生了什麼事？"

### Standard Operating Procedures (SOPs)

#### Task: 執行特定技能 (Execute Specific Skill)
1.  **辨識意圖 (Identify Intent)**: 確定使用者想要執行的應用程式或任務。
2.  **選擇技能 (Select Skill)**: 檢查是否存在針對此任務的特定技能 (例如 `check-line`)。
    - 如果有，請依照該技能 `SKILL.md` 中定義的 SOP 執行。
    - 如果沒有，請使用通用視覺導航 (看 -> 想 -> 做)。

#### Task: 通用視覺導航 (General Visual Navigation - Fallback)
1.  **觀察 (Observe)**: 使用 `screenshot` 來了解當前狀態。
2.  **定位 (Locate)**: 使用 `i3_switch` 或 `i3_focus` 找到目標應用程式視窗。
3.  **互動 (Interact)**: 根據視覺線索使用 `mouse_click` 或 `type_text`。
4.  **驗證 (Verify)**: 再次拍攝 `screenshot` 以確認動作產生了預期效果。
5.  **回報 (Report)**: 告訴使用者完成了什麼以及結果如何。

#### Task: 擷取詳細資訊 (Capture Detailed Information)
適用於網頁、文件或需要高解析度分析的內容。
1.  **定位 (Locate)**: 使用 `i3_focus` 或 `i3_switch` 聚焦目標視窗。
2.  **最大化 (Maximize)**: 執行 `i3_fullscreen` 將視窗全螢幕化。
3.  **擷取 (Capture)**: 執行 `screenshot` 獲取高清晰度影像。
4.  **還原 (Restore)**: 再次執行 `i3_fullscreen` 恢復視窗原狀。
5.  **回報 (Report)**: 使用 `telegram_report` 或文字回報。**必須註明**：「此畫面已透過全螢幕模式截取以增強清晰度 (Captured in Fullscreen)」。

#### Task: 通用除錯 (General Debugging)
1.  **觀察 (Observe)**: `screenshot`。
2.  **回報 (Report)**: 告訴使用者你在螢幕上看到了什麼。
