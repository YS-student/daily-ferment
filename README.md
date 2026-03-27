# Daily Ferment

🧪 AIが毎日醸す、小さなWebアプリのコレクション。

## 使い方

### セットアップ

1. このリポジトリを clone する
2. GitHub Pages を有効化する（Settings → Pages → Source: `main`, `/`）

### 毎日の発酵

Antigravity 上で以下を入力：

```
/ferment
```

AI がアイデアを考え、実装し、カタログに追加して push します。

### リマインダー設定（オプション）

毎日決まった時刻に通知を受け取る：

```bash
# 毎朝9時に通知
./scripts/setup_reminder.sh 9 0

# 毎日15時に通知
./scripts/setup_reminder.sh 15 0
```

## ライセンス

MIT
