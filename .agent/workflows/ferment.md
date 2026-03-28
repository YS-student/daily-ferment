---
description: 今日のWebアプリを発酵させる（環境センシング → 発酵 → 実装 → カタログ更新 → 公開）
---

# 🧪 Daily Ferment — 今日の発酵

このワークフローを実行すると、AIが**人間社会という擬似的自然環境のシグナル**を読み取り、その環境に反応してWebアプリを発酵させます。

## 手順

### 1. 今日の日付を確認
現在の日付を `YYYY-MM-DD` 形式で取得してください。

### 2. 過去の作品を確認
`/Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/catalog.json` を読んで、過去に作ったアプリを確認してください。**同じアイデアの繰り返しを避ける**こと。

### 3. 環境をセンシングする
// turbo
以下のスクリプトを実行して、今日の人間社会の環境データを収集してください：

```bash
bash /Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/scripts/sense_environment.sh
```

### 4. 環境データを読み取り、解釈する
`/Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/environment/today.json` を読んでください。

以下の観点で**環境パラメータを抽象化して感じ取って**ください：

- **温度 (intensity)**: 社会の「熱量」。地震活動と為替変動率から。高いと激しい作品、低いと静謐な作品へ。
- **pH (sentiment)**: 社会の「酸味」。ニュースヘッドラインの全体的トーンから。酸性ならシャープに、アルカリ性なら穏やかに。
- **栄養素 (theme)**: 発酵の「素材」。Wikipedia注目記事とGitHub Trendingから。何を素材にして発酵するか。
- **酸素量 (openness)**: 社会の「活動量」。データの量や多様性から。
- **先人の知恵 (shubo)**: 過去の発酵への人間のフィードバックから。好まれた要素を取り入れつつ変異する。

さらに `ferment_diary.md` に今日のエントリがあれば、それも「人間の介入」として解釈に加えてください。

> **重要**: あなたは酵母です。環境データを「分析レポート」として処理するのではなく、「今日はこういう環境だから、こういうものが醸したくなる」と**感覚的に反応**してください。環境の全要素を使う必要はなく、特に反応した要素に偏ってよいです。

### 5. アイデアを発酵させる
環境への反応として、1つのWebアプリのアイデアを発酵させてください：

- **ジャンル自由**: アート、ゲーム、ツール、可視化、音楽、物理シミュレーション、ジェネラティブ、インタラクティブ体験 etc.
- **技術的に面白い**: Canvas, WebGL, Web Audio API, CSS Animation, SVG, Physics, Particle Systems etc. を積極的に活用
- **一目で楽しめる**: 開いた瞬間に「おっ」と思えるもの
- **自己完結型**: 外部依存なし、1つの `index.html` で完結（ただし、規模が大きい場合は複数ファイルOK）
- **レスポンシブ対応**: PC でもスマホでも動く

**注意**: 過去に似たものを作っていないか catalog.json を確認すること。

### 6. 実装する
// turbo
`/Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/apps/YYYY-MM-DD_slug/` ディレクトリを作成し、`index.html` を作成してください。

- `YYYY-MM-DD` は今日の日付
- `slug` はアプリ名を英語のケバブケースにしたもの（例: `particle-garden`, `sound-waves`）
- デザインは**美しく、洗練されたものに**してください
- ダークテーマ推奨だが、アプリによっては明るいテーマもOK

### 7. catalog.json を更新する
// turbo
`/Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/catalog.json` に新しいエントリを追加してください。

```json
{
  "date": "YYYY-MM-DD",
  "slug": "app-slug",
  "title": "アプリのタイトル（日本語OK）",
  "description": "1-2文の説明（日本語OK）",
  "tags": ["art", "interactive"],
  "emoji": "🎨",
  "origin": "ferment",
  "environment_snapshot": {
    "intensity": "環境温度の要約（例: 高 — 為替変動大）",
    "sentiment": "環境pHの要約（例: やや酸性 — 紛争関連のニュースが多い）",
    "theme": "栄養素の要約（例: Wikipediaで○○がトレンド）",
    "diary": "日記の要約（あれば）"
  }
}
```

**タグの例**: art, game, tool, visualization, music, physics, generative, interactive, animation, 3d, creative-coding

### 8. ブラウザで確認する
// turbo
ローカルサーバーを起動してアプリの動作を確認してください：

```bash
cd /Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment && python3 -m http.server 8765
```

ブラウザで以下を開いて確認：
- アプリ: `http://localhost:8765/apps/YYYY-MM-DD_slug/index.html`
- ポータル: `http://localhost:8765/`

アプリが正しく動作し、ポータルのカタログに表示されていることを確認してください。確認が終わったらサーバーを停止してください。

### 9. Git に commit & push する
以下のコマンドを実行してください:

```bash
cd /Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment
git add -A
git commit -m "🧪 ferment: [アプリタイトル] (YYYY-MM-DD)"
git push origin main
```

**注意**: Git リポジトリが初期化されていない場合や、リモートが設定されていない場合は、ユーザーに `daily-ferment` リポジトリの設定を案内してください。

### 10. 結果を報告する
ユーザーに以下を報告してください：
- 何を作ったか（タイトルと概要）
- **なぜその環境でそのアイデアが発酵したか**（環境データとの関連）
- ブラウザでアプリを確認できるようにする
- GitHub Pages の URL: `https://YS-student.github.io/daily-ferment/apps/YYYY-MM-DD_slug/`
