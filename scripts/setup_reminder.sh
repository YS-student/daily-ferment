#!/bin/bash
# ===================================
# Daily Ferment — リマインダーセットアップ
# macOS launchd を使って毎日通知を表示
# ===================================

set -e

# デフォルト時刻（24時間形式）
HOUR="${1:-9}"
MINUTE="${2:-0}"

PLIST_NAME="com.dailyferment.reminder"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"

echo "🧪 Daily Ferment リマインダーをセットアップします"
echo "   通知時刻: ${HOUR}:$(printf '%02d' $MINUTE)"
echo ""

# LaunchAgents ディレクトリを作成
mkdir -p "$HOME/Library/LaunchAgents"

# plist を作成
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_NAME}</string>
    <key>ProgramArguments</key>
    <array>
        <string>osascript</string>
        <string>-e</string>
        <string>display notification "Antigravityを開いて /ferment を実行しよう 🧫" with title "🧪 Daily Ferment" subtitle "今日の発酵の時間です"</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>${HOUR}</integer>
        <key>Minute</key>
        <integer>${MINUTE}</integer>
    </dict>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
EOF

# 既存のジョブをアンロード（エラーは無視）
launchctl unload "$PLIST_PATH" 2>/dev/null || true

# ジョブをロード
launchctl load "$PLIST_PATH"

echo "✅ セットアップ完了！"
echo "   毎日 ${HOUR}:$(printf '%02d' $MINUTE) に通知が届きます。"
echo ""
echo "📋 管理コマンド:"
echo "   停止: launchctl unload ${PLIST_PATH}"
echo "   再開: launchctl load ${PLIST_PATH}"
echo "   削除: launchctl unload ${PLIST_PATH} && rm ${PLIST_PATH}"
echo "   テスト: osascript -e 'display notification \"テスト通知\" with title \"🧪 Daily Ferment\"'"
