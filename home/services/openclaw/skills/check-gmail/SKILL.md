# SKILL.md

## Name
check-gmail

## Description
一個專門的技能，用於視覺化檢查 Gmail 信箱的新郵件並回報重要內容。
A specialized skill to visually check Gmail for new messages and report important content.

## Tools Required
- `i3_focus`
- `i3_fullscreen`
- `screenshot`
- `mouse_click`
- `telegram_report`

## SOP: Check Gmail (檢查 Gmail)
1.  **定位 (Locate)**: 使用 `i3_focus("Google-chrome")` 或 `i3_focus("Firefox")` 找到瀏覽器視窗。
2.  **最大化 (Maximize)**: 執行 `i3_fullscreen` 以獲得最佳視野。
3.  **視覺檢查 (Visual Check)**: 執行 `screenshot`。
    - 尋找 Gmail 分頁或介面。
    - 尋找「未讀」郵件（粗體字、括號數字）。
4.  **行動 (Action)**:
    - 如果未在 Gmail 畫面：嘗試尋找 Gmail 分頁並點擊，或回報「找不到 Gmail 畫面」。
    - 如果發現重要未讀郵件：點擊郵件，再次 `screenshot` 讀取內容。
5.  **還原 (Restore)**: 執行 `i3_fullscreen` 恢復視窗原狀。
6.  **回報 (Report)**: 使用 `telegram_report` 總結未讀郵件。例如：「Gmail 更新：收到來自 AWS 的帳單通知。」
