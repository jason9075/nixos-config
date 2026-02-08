# SKILL.md

## Name
webcam

## Description
使用網路攝影機拍攝照片。
Capture a photo using the webcam.

## Tools Required
- `webcam_capture`

## Tools Definition

### webcam_capture
啟動網路攝影機並拍照。
- **Command**: `fswebcam -r 1280x720 --no-banner --skip 20 --jpeg 95 /tmp/webcam.jpg && echo "/tmp/webcam.jpg"`
- **Description**: 拍攝一張照片並回傳路徑。會跳過前 20 幀以等待相機初始化（避免黑畫面或曝光不足）。

## SOP: Take Photo (拍照)
1.  **Action**: 執行 `webcam_capture`。
2.  **Report**: 回報照片已儲存於回傳的路徑 (例如 `/tmp/webcam.jpg`)。可以使用其他工具 (如 Telegram) 發送該照片。
