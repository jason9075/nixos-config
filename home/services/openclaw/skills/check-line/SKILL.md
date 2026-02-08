# SKILL.md

## Name
check-line

## Description
一個專門的技能，用於視覺化檢查 LINE 通訊應用程式的新訊息並回報。

## Tools Required
- `i3_switch`
- `i3_focus`
- `screenshot`
- `mouse_click`
- `telegram_report`

## SOP: Check LINE and Report (檢查 LINE 並回報)
1.  **切換情境 (Switch Context)**: 使用 `i3_switch(9)` (假設 LINE 在 WS 9) 或 `i3_switch(1)`。
2.  **聚焦應用程式 (Focus App)**: 使用 `i3_focus("Line")` (如果是 Wine 則可能是 "line.exe"，請檢查 `xwininfo`)。
3.  **視覺檢查 (Visual Check)**: 使用 `screenshot`。分析圖片尋找：
    - 新訊息徽章 (紅點)。
    - 聊天列表中的關鍵字 ("Boss", "Urgent", "緊急", "老闆")。
4.  **行動 (Action)**:
    - 如果發現新訊息：`mouse_click` 點擊聊天。
    - 再次 `screenshot` 以讀取內容。
5.  **回報 (Report)**: 使用 `telegram_report` 總結發現。例如："LINE 更新：媽媽問你什麼時候回家。"
