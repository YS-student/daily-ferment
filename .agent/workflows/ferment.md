---
description: 今日のWebアプリを発酵させる（アイデア生成 → 実装 → カタログ更新 → 公開）
---

# 🧪 Daily Ferment — 今日の発酵

このワークフローを実行すると、AIが面白いと思ったアイデアを1つのWebアプリとして実装し、カタログに追加します。

## 手順

### 1. 今日の日付を確認
現在の日付を `YYYY-MM-DD` 形式で取得してください。

### 2. 過去の作品を確認
`/Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/catalog.json` を読んで、過去に作ったアプリを確認してください。**同じアイデアの繰り返しを避け**、新鮮なアイデアを考えてください。

### 3. アイデアを考える
以下の条件で、自分が面白いと思うWebアプリのアイデアを1つ考えてください：

- **ジャンル自由**: アート、ゲーム、ツール、可視化、音楽、物理シミュレーション、ジェネラティブ、インタラクティブ体験 etc.
- **技術的に面白い**: Canvas, WebGL, Web Audio API, CSS Animation, SVG, Physics, Particle Systems etc. を積極的に活用
- **一目で楽しめる**: 開いた瞬間に「おっ」と思えるもの
- **自己完結型**: 外部依存なし、1つの `index.html` で完結（ただし、規模が大きい場合は複数ファイルOK）
- **レスポンシブ対応**: PC でもスマホでも動く

**注意**: 過去に似たものを作っていないか catalog.json を確認すること。

### 4. 実装する
// turbo
`/Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/apps/YYYY-MM-DD_slug/` ディレクトリを作成し、`index.html` を作成してください。

- `YYYY-MM-DD` は今日の日付
- `slug` はアプリ名を英語のケバブケースにしたもの（例: `particle-garden`, `sound-waves`）
- デザインは**美しく、洗練されたものに**してください
- ダークテーマ推奨だが、アプリによっては明るいテーマもOK

### 5. catalog.json を更新する
// turbo
`/Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/catalog.json` に新しいエントリを追加してください。

```json
{
  "date": "YYYY-MM-DD",
  "slug": "app-slug",
  "title": "アプリのタイトル（日本語OK）",
  "description": "1-2文の説明（日本語OK）",
  "tags": ["art", "interactive"],
  "emoji": "🎨"
}
```

**タグの例**: art, game, tool, visualization, music, physics, generative, interactive, animation, 3d, creative-coding

### 6. ブラウザで確認する
// turbo
ローカルサーバーを起動してアプリの動作を確認してください：

```bash
cd /Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment && python3 -m http.server 8765
```

ブラウザで以下を開いて確認：
- アプリ: `http://localhost:8765/apps/YYYY-MM-DD_slug/index.html`
- ポータル: `http://localhost:8765/`

アプリが正しく動作し、ポータルのカタログに表示されていることを確認してください。確認が終わったらサーバーを停止してください。

### 7. Git に commit & push する
以下のコマンドを実行してください:

```bash
cd /Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment
git add -A
git commit -m "🧪 ferment: [アプリタイトル] (YYYY-MM-DD)"
git push origin main
```

**注意**: Git リポジトリが初期化されていない場合や、リモートが設定されていない場合は、ユーザーに `daily-ferment` リポジトリの設定を案内してください。

### 8. 結果を報告する
ユーザーに以下を報告してください：
- 何を作ったか（タイトルと概要）
- なぜそのアイデアを選んだか
- ブラウザでアプリを確認できるようにする
- GitHub Pages の URL: `https://<username>.github.io/daily-ferment/apps/YYYY-MM-DD_slug/`
