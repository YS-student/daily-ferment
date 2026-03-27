# Daily Ferment — セットアップ手順書

ゼロから Daily Ferment を構築し、GitHub Pages で公開するまでの完全な手順。

---

## 前提

- macOS
- Git がインストール済み（`/opt/homebrew/bin/git`）
- GitHub アカウントを持っている

---

## 1. GitHubでリポジトリを作成

1. [github.com/new](https://github.com/new) にアクセス
2. **Repository name**: `daily-ferment`
3. **Public** を選択
4. その他はデフォルトのまま
5. 「**Create repository**」をクリック

---

## 2. GitHub Pages を有効化

1. 作成したリポジトリページで **Settings** タブをクリック
2. 左サイドバーの **Pages** をクリック
3. **Source** セクションで：
   - **Branch**: `main` を選択
   - **Folder**: `/ (root)` を選択
4. **Save** をクリック

> ⚠️ この時点ではまだ何も push していないので、Pagesは空です。push 後に反映されます。

---

## 3. ローカルのコードをリポジトリに接続

```bash
# プロジェクトフォルダに移動
cd /Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment

# Gitリポジトリを初期化
git init

# メインブランチを main に設定
git branch -M main

# GitHubリモートを追加（URLは自分のユーザー名に置き換え）
git remote add origin https://github.com/<ユーザー名>/daily-ferment.git
```

**やっていること**: PC上のフォルダとGitHubのサーバーを接続するパイプを作っている。

---

## 4. 認証設定（Personal Access Token）

GitHub はパスワード認証を廃止済み。代わりに **PAT（トークン）** を使う。

### トークン作成手順

1. GitHub にログインした状態で以下にアクセス：
   👉 https://github.com/settings/tokens
2. **「Generate new token」→「Generate new token (classic)」**
3. 設定：
   - **Note**: `daily-ferment`（メモ用、何でもOK）
   - **Expiration**: 好きな期限（90日 / 1年 / No expiration）
   - **Select scopes**: ✅ `repo` にチェック
4. 「**Generate token**」をクリック
5. 表示されたトークン（`ghp_xxxx...`）を**コピーして控える**（二度と表示されない）

### キーチェーンに保存（毎回入力不要にする）

```bash
git config --global credential.helper osxkeychain
```

---

## 5. 初回 push

```bash
cd /Users/sugimotoyuuki/.gemini/antigravity/scratch/daily-ferment
git add -A
git commit -m "🧪 Initial setup: Daily Ferment portal"
git push -u origin main
```

push 時に認証を聞かれたら：
- **Username**: GitHubのユーザー名
- **Password**: コピーした**トークン**（`ghp_xxxx...`）

---

## 6. 公開確認

数分待ってから以下にアクセス：

```
https://<ユーザー名>.github.io/daily-ferment/
```

ポータルサイトが表示されれば成功 🎉

---

## 日常の使い方

### アプリを生成する
Antigravity 上で以下を入力：
```
/ferment
```

### リマインダーを設定する（任意）
```bash
# 毎朝9時に通知
./scripts/setup_reminder.sh 9 0
```

---

## 料金

| サービス | 料金 |
|---------|------|
| GitHub Pages（Publicリポ） | 無料 |
| Personal Access Token | 無料 |
| GitHub リポジトリ（Public） | 無料 |

制限: ストレージ1GB / 帯域100GB/月（Daily Fermentには十分）
