#!/bin/bash
# ============================================================
# sense_environment.sh — 人間社会の擬似的自然環境を計測する
# ============================================================
# 無料APIから偏りなくグローバルなデータを収集し、
# environment/today.json に保存する。
# /ferment ワークフローの前段で実行される。
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_DIR="$PROJECT_DIR/environment"
OUTPUT="$ENV_DIR/today.json"
DIARY_FILE="$PROJECT_DIR/ferment_diary.md"
FEEDBACK_FILE="$PROJECT_DIR/feedback.json"

mkdir -p "$ENV_DIR"

DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
# Yesterday for Wikipedia (data is available for the previous day)
if [[ "$(uname)" == "Darwin" ]]; then
  YESTERDAY=$(date -v-1d +%Y/%m/%d)
  YESTERDAY_Y=$(date -v-1d +%Y)
  YESTERDAY_M=$(date -v-1d +%m)
  YESTERDAY_D=$(date -v-1d +%d)
else
  YESTERDAY=$(date -d "yesterday" +%Y/%m/%d)
  YESTERDAY_Y=$(date -d "yesterday" +%Y)
  YESTERDAY_M=$(date -d "yesterday" +%m)
  YESTERDAY_D=$(date -d "yesterday" +%d)
fi

echo "📡 環境センシング開始: $DATE"
echo "========================================"

# ----- Temporary files -----
TMP_DIR="$ENV_DIR/.tmp"
mkdir -p "$TMP_DIR"
trap "rm -rf $TMP_DIR" EXIT

# ============================================================
# 1. WIKIPEDIA — 集合的関心（3言語: en, ja, es）
# ============================================================
echo "🌐 Wikipedia 注目記事を取得中..."

fetch_wiki_top() {
  local lang=$1
  local url="https://wikimedia.org/api/rest_v1/metrics/pageviews/top/${lang}.wikipedia/all-access/${YESTERDAY_Y}/${YESTERDAY_M}/${YESTERDAY_D}"
  curl -sS --max-time 15 -H "User-Agent: DailyFerment/1.0 (https://github.com/YS-student/daily-ferment)" "$url" 2>/dev/null \
    | jq -r '[.items[0].articles[] | select(.article | test("^(Main_Page|Special:|Wikipedia:|メインページ|特別:|Wikipedia:)") | not) | .article] | .[0:10]' 2>/dev/null \
    || echo '[]'
}

WIKI_EN=$(fetch_wiki_top "en")
WIKI_JA=$(fetch_wiki_top "ja")
WIKI_ES=$(fetch_wiki_top "es")

echo "  ✅ Wikipedia: en=$(echo "$WIKI_EN" | jq length) / ja=$(echo "$WIKI_JA" | jq length) / es=$(echo "$WIKI_ES" | jq length) articles"

# ============================================================
# 2. NEWS RSS — 集合的関心＋感情（3地域: NHK, BBC, Al Jazeera）
# ============================================================
echo "📰 ニュースヘッドラインを取得中..."

fetch_rss_titles() {
  local url=$1
  local count=${2:-10}
  curl -sS --max-time 15 "$url" 2>/dev/null \
    | grep -oP '(?<=<title>).*?(?=</title>)' \
    | head -n "$count" \
    | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&#39;/'"'"'/g' \
    | jq -R -s 'split("\n") | map(select(length > 0))' 2>/dev/null \
    || echo '[]'
}

# macOS grep doesn't support -P, use alternative
if [[ "$(uname)" == "Darwin" ]]; then
  fetch_rss_titles() {
    local url=$1
    local count=${2:-10}
    curl -sS --max-time 15 "$url" 2>/dev/null \
      | sed -n 's:.*<title>\(.*\)</title>.*:\1:p' \
      | sed 's/<\!\[CDATA\[//g; s/\]\]>//g' \
      | head -n "$count" \
      | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&#8211;/—/g; s/&#39;/'"'"'/g' \
      | jq -R -s 'split("\n") | map(select(length > 0))' 2>/dev/null \
      || echo '[]'
  }
fi

NEWS_NHK=$(fetch_rss_titles "https://www3.nhk.or.jp/rss/news/cat0.xml" 10)
NEWS_BBC=$(fetch_rss_titles "https://feeds.bbci.co.uk/news/world/rss.xml" 10)
NEWS_AJ=$(fetch_rss_titles "https://www.aljazeera.com/xml/rss/all.xml" 10)

echo "  ✅ News: NHK=$(echo "$NEWS_NHK" | jq length) / BBC=$(echo "$NEWS_BBC" | jq length) / AJ=$(echo "$NEWS_AJ" | jq length) headlines"

# ============================================================
# 3. EXCHANGE RATES — 集合的行動（6通貨ペア）
# ============================================================
echo "💱 為替レートを取得中..."

FX_TODAY=$(curl -sS --max-time 15 "https://api.frankfurter.app/latest?base=USD&symbols=EUR,JPY,CNY,GBP,BRL,KRW" 2>/dev/null || echo '{}')

# Get yesterday's rates for change calculation
if [[ "$(uname)" == "Darwin" ]]; then
  FX_DATE_PREV=$(date -v-1d +%Y-%m-%d)
else
  FX_DATE_PREV=$(date -d "yesterday" +%Y-%m-%d)
fi
FX_PREV=$(curl -sS --max-time 15 "https://api.frankfurter.app/${FX_DATE_PREV}?base=USD&symbols=EUR,JPY,CNY,GBP,BRL,KRW" 2>/dev/null || echo '{}')

# Calculate percentage changes
FX_CHANGES=$(jq -n \
  --argjson today "$FX_TODAY" \
  --argjson prev "$FX_PREV" \
  '($today.rates // {}) as $t | ($prev.rates // {}) as $p |
   [to_entries[] | select(false)] | {} as $empty |
   ($t | keys) as $keys |
   reduce ($keys[]) as $k ($empty;
     if ($p[$k] // 0) != 0
     then . + { ($k): ((($t[$k] - $p[$k]) / $p[$k]) * 100 | . * 100 | round / 100) }
     else . + { ($k): 0 }
     end
   )' 2>/dev/null || echo '{}')

echo "  ✅ FX: $(echo "$FX_TODAY" | jq '.rates | length') currencies"

# ============================================================
# 4. EARTHQUAKES — 地球規模の活動（USGS, M2.5+, 24h）
# ============================================================
echo "🌍 地震データを取得中..."

EQ_DATA=$(curl -sS --max-time 15 "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$(date -u +%Y-%m-%dT00:00:00)&minmagnitude=2.5&limit=50" 2>/dev/null || echo '{"features":[]}')

EQ_COUNT=$(echo "$EQ_DATA" | jq '.features | length' 2>/dev/null || echo "0")
EQ_MAX_MAG=$(echo "$EQ_DATA" | jq '[.features[].properties.mag] | max // 0' 2>/dev/null || echo "0")
EQ_REGIONS=$(echo "$EQ_DATA" | jq '[.features[].properties.place] | unique | .[0:8]' 2>/dev/null || echo '[]')

echo "  ✅ Earthquakes: $EQ_COUNT events, max magnitude: $EQ_MAX_MAG"

# ============================================================
# 5. GITHUB TRENDING — テック・創造活動
# ============================================================
echo "💻 GitHub Trending を取得中..."

GH_TRENDING=$(curl -sS --max-time 15 "https://github.com/trending" 2>/dev/null \
  | sed -n 's:.*<h2 class="h3 lh-condensed">.*<a[^>]*>\s*\(.*\)\s*</a>.*:\1:p' \
  | sed 's/^ *//; s/ *$//; s|/| / |g' \
  | head -n 10 \
  | jq -R -s 'split("\n") | map(select(length > 0))' 2>/dev/null \
  || echo '[]')

# Fallback: try alternative parsing if empty
if [ "$(echo "$GH_TRENDING" | jq length)" -eq 0 ]; then
  GH_TRENDING=$(curl -sS --max-time 15 "https://github.com/trending" 2>/dev/null \
    | grep -o 'href="/[^"]*/[^"]*"' \
    | grep -v '/trending\|/topics\|/collections\|/explore\|/features\|/pricing\|/login\|/signup\|/settings\|/notifications\|/about\|/contact\|/sponsors\|/stars\|/marketplace\|assets\|\.css\|\.js\|\.svg\|\.png\|/stargazers\|/forks\|/issues\|/pulls\|/actions\|/wiki\|/network' \
    | sed 's|href="/||; s|"$||' \
    | head -n 10 \
    | jq -R -s 'split("\n") | map(select(length > 0))' 2>/dev/null \
    || echo '[]')
fi

# Remove stargazers/forks/issues links from results
GH_TRENDING=$(echo "$GH_TRENDING" | jq '[.[] | select(test("/stargazers|/forks|/issues|/pulls|/actions") | not)]' 2>/dev/null || echo "$GH_TRENDING")

echo "  ✅ GitHub: $(echo "$GH_TRENDING" | jq length) trending repos"

# ============================================================
# 6. DIARY — 人間の介入（任意）
# ============================================================
echo "📝 発酵日記を確認中..."

DIARY_ENTRY=""
if [ -f "$DIARY_FILE" ]; then
  # Extract today's entry (search for ## YYYY-MM-DD header)
  DIARY_ENTRY=$(awk "/^## $DATE/{found=1; next} /^## [0-9]{4}/ && found{exit} found" "$DIARY_FILE" | sed '/^$/d')
  if [ -n "$DIARY_ENTRY" ]; then
    echo "  ✅ 日記あり: $(echo "$DIARY_ENTRY" | head -1)..."
  else
    echo "  ℹ️  今日の日記はありません"
  fi
else
  echo "  ℹ️  ferment_diary.md が見つかりません"
fi

# ============================================================
# 7. FEEDBACK — 酒母（過去のフィードバック）
# ============================================================
echo "🧫 酒母（フィードバック）を確認中..."

FEEDBACK='{}'
if [ -f "$FEEDBACK_FILE" ]; then
  FEEDBACK=$(cat "$FEEDBACK_FILE")
  echo "  ✅ フィードバックデータあり"
else
  echo "  ℹ️  まだフィードバックはありません"
fi

# ============================================================
# 出力: environment/today.json
# ============================================================
echo ""
echo "📦 today.json を生成中..."

jq -n \
  --arg date "$DATE" \
  --arg timestamp "$TIMESTAMP" \
  --argjson wiki_en "$WIKI_EN" \
  --argjson wiki_ja "$WIKI_JA" \
  --argjson wiki_es "$WIKI_ES" \
  --argjson news_nhk "$NEWS_NHK" \
  --argjson news_bbc "$NEWS_BBC" \
  --argjson news_aj "$NEWS_AJ" \
  --argjson fx_rates "$(echo "$FX_TODAY" | jq '.rates // {}')" \
  --argjson fx_changes "$FX_CHANGES" \
  --arg eq_count "$EQ_COUNT" \
  --arg eq_max "$EQ_MAX_MAG" \
  --argjson eq_regions "$EQ_REGIONS" \
  --argjson gh_trending "$GH_TRENDING" \
  --arg diary "$DIARY_ENTRY" \
  --argjson feedback "$FEEDBACK" \
'{
  date: $date,
  collected_at: $timestamp,
  wikipedia: {
    en: $wiki_en,
    ja: $wiki_ja,
    es: $wiki_es
  },
  news_headlines: {
    nhk: $news_nhk,
    bbc: $news_bbc,
    aljazeera: $news_aj
  },
  exchange_rates: {
    base: "USD",
    rates: $fx_rates,
    changes_pct: $fx_changes
  },
  earthquakes: {
    count_24h: ($eq_count | tonumber),
    max_magnitude: ($eq_max | tonumber),
    regions: $eq_regions
  },
  github_trending: $gh_trending,
  diary: (if $diary == "" then null else $diary end),
  feedback: $feedback
}' > "$OUTPUT"

echo "========================================"
echo "✅ 環境センシング完了: $OUTPUT"
echo "📊 データサマリー:"
echo "   Wikipedia: $(echo "$WIKI_EN" | jq length)+$(echo "$WIKI_JA" | jq length)+$(echo "$WIKI_ES" | jq length) articles (en+ja+es)"
echo "   News:      $(echo "$NEWS_NHK" | jq length)+$(echo "$NEWS_BBC" | jq length)+$(echo "$NEWS_AJ" | jq length) headlines (NHK+BBC+AJ)"
echo "   FX:        $(echo "$FX_TODAY" | jq '.rates | length') currencies"
echo "   Quakes:    $EQ_COUNT events (max M${EQ_MAX_MAG})"
echo "   GitHub:    $(echo "$GH_TRENDING" | jq length) trending repos"
echo "   Diary:     $([ -n "$DIARY_ENTRY" ] && echo 'あり' || echo 'なし')"
echo "   Feedback:  $([ "$FEEDBACK" != '{}' ] && echo 'あり' || echo 'なし')"
