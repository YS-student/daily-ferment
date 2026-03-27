# Daily Ferment — 毎日Webアプリを醸す仕組み

Antigravityを「発酵的な存在」として機能させるシステム。毎日、面白いアイデアをWebアプリとして実装し、GitHub Pagesで自動公開する。

## User Review Required

> [!IMPORTANT]
> **GitHubリポジトリの準備が必要です**
> - GH CLI (`gh`) がインストールされていないため、GitHubリポジトリの作成とGitHub Pagesの有効化は手動で行っていただく必要があります（手順は下記に記載）。
> - SSH鍵またはHTTPSトークンの設定も必要です。

> [!IMPORTANT]
> **自動起動の仕組みについて**
> Antigravityには外部からプログラム的に起動するAPIがありません。そのため、完全自動ではなく以下の2つのアプローチを提案します：
>
> **案A: 半自動（推奨）** — macOS `launchd` で毎日決まった時間にリマインダー通知を表示 → Antigravityを開いて `/ferment` ワークフローを実行
>
> **案B: 手動** — Antigravityを開いたとき好きなタイミングで `/ferment` ワークフローを実行
>
> どちらが良いですか？

## システム構成

```
daily-ferment/           ← GitHubリポジトリ
├── index.html           ← ポータルサイト（アプリ一覧）
├── style.css            ← ポータルのスタイル
├── catalog.json         ← 生成されたアプリのカタログデータ
└── apps/
    ├── 2026-03-28_particle-garden/
    │   └── index.html   ← 自己完結型Webアプリ
    ├── 2026-03-29_sound-waves/
    │   └── index.html
    └── ...
```

## Proposed Changes

---

### 1. GitHubリポジトリのセットアップ（ユーザー手動）

以下の手順をユーザーに依頼します：

1. GitHubで `daily-ferment` リポジトリを作成（Public）
2. Settings → Pages → Source を `main` ブランチの `/` (root) に設定
3. ローカルにclone：`git clone https://github.com/<username>/daily-ferment.git`
4. HTTPS pushのためにPersonal Access Token（PAT）の設定、または SSH鍵の設定

---

### 2. ポータルサイト（アプリ一覧ページ）

#### [NEW] [index.html](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/index.html)
- 生成済みアプリのカタログを美しく表示するポータルサイト
- `catalog.json` を読み込み、カード形式でアプリ一覧を表示
- ダークモード、グラスモーフィズム、アニメーション付きのモダンUI
- 各カードにアプリ名・説明・生成日・サムネイル・リンクを表示
- レスポンシブ対応

#### [NEW] [style.css](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/style.css)
- ポータルサイトのスタイルシート
- ダークテーマベースのデザインシステム
- カードのホバーアニメーション
- グラデーション背景

#### [NEW] [catalog.json](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/catalog.json)
- 生成されたアプリのメタデータを格納するJSONファイル
- 構造: `[{ "date", "slug", "title", "description", "tags", "emoji" }]`

---

### 3. Antigravityワークフロー（`/ferment`コマンド）

#### [NEW] [ferment.md](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/.agent/workflows/ferment.md)

ワークフロー定義ファイル。Antigravity上で `/ferment` と入力するだけで以下が実行される：

1. **アイデア生成** — AIが今日の気分で面白いWebアプリのアイデアを考える
2. **実装** — HTML/CSS/JS の自己完結型Webアプリを `apps/YYYY-MM-DD_slug/index.html` に作成
3. **カタログ更新** — `catalog.json` に新しいアプリを追加
4. **Git操作** — commit & push
5. **報告** — 何を作ったかをユーザーに通知

---

### 4. macOS定時リマインダー（案Aの場合）

#### [NEW] [setup_reminder.sh](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/scripts/setup_reminder.sh)
- macOS `launchd` を使った定時通知のセットアップスクリプト
- 指定時刻に「今日の発酵の時間です 🧪」という通知を表示
- ユーザーが好きな時刻を指定可能

---

## Verification Plan

### ブラウザテスト
1. ポータルサイトをローカルで開き、デザインと機能を確認
2. サンプルアプリを1つ生成し、カタログに正しく表示されることを確認

### 手動テスト
1. `/ferment` ワークフローを実行し、アプリが正しく生成されることを確認
2. `catalog.json` が正しく更新されることを確認
3. Git commit & push が成功することを確認（リポジトリ設定後）
4. GitHub Pages でポータルとアプリにアクセスできることを確認
