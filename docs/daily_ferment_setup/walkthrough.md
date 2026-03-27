# Daily Ferment — Walkthrough

## 概要

AIを「発酵的な存在」として機能させるシステム **Daily Ferment** を構築しました。Antigravity上で `/ferment` と入力するだけで、AIが面白いWebアプリを生成し、GitHub Pagesで公開できます。

## 構築したもの

### ポータルサイト
ダークモード・グラスモーフィズムベースのモダンなデザインで、生成されたアプリを一覧表示します。

````carousel
![ポータルサイト — アプリカードが表示されている状態](/Users/sugimotoyuuki/.gemini/antigravity/brain/6692d36c-7a83-442f-924e-67cb5af1f88a/portal_card_screenshot.png)
<!-- slide -->
![サンプルアプリ: Particle Orbit](/Users/sugimotoyuuki/.gemini/antigravity/brain/6692d36c-7a83-442f-924e-67cb5af1f88a/particle_orbit_screenshot.png)
````

### ファイル構成

| ファイル | 役割 |
|---------|------|
| [index.html](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/index.html) | ポータルサイト |
| [style.css](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/style.css) | デザインシステム |
| [catalog.json](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/catalog.json) | アプリカタログ |
| [ferment.md](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/.agent/workflows/ferment.md) | `/ferment` ワークフロー |
| [setup_reminder.sh](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/scripts/setup_reminder.sh) | 定時リマインダーセットアップ |
| [README.md](file:///Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment/README.md) | リポジトリ説明 |

### サンプルアプリ
- **Particle Orbit** — 600個のパーティクルが引力場で軌道を描くインタラクティブ体験

## 検証結果

| 項目 | 結果 |
|------|------|
| ポータルUI表示 | ✅ 正常 |
| 統計表示（Total/Streak/Latest） | ✅ 正常 |
| フィルタタグ | ✅ 正常 |
| アプリカード表示 | ✅ 正常 |
| サンプルアプリ動作 | ✅ 正常 |

## 次のステップ

> [!IMPORTANT]
> 以下のGitHub設定をユーザーが手動で行う必要があります：
> 1. GitHubで `daily-ferment` リポジトリを作成（Public）
> 2. Settings → Pages → Source を `main` / `/` に設定
> 3. ローカルで `git init` → `git remote add origin` → `git push`
> 4. 毎日 `/ferment` を実行して発酵開始！
