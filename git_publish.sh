#!/bin/bash
# 1. このスクリプトがある場所（workspace）へ移動
cd "$(dirname "$0")"

CONTENT=$1
SUFFIX=${2:-""}  # 第2引数でサフィックス指定（例: "-moltbook"）
DATE=$(date +'%Y-%m-%d')
FILENAME="posts/${DATE}${SUFFIX}.md"

# 2. 記事を保存（Jekyllレイアウト付き）
mkdir -p posts
{
  echo "---"
  echo "layout: default"
  echo "title: ${DATE}${SUFFIX} 稼働日誌"
  echo "---"
  echo ""
  echo "$CONTENT"
} > "$FILENAME"

# 3. index.md（目次）を自動生成
{
  echo "---"
  echo "layout: default"
  echo "title: AI要塞 稼働日誌"
  echo "---"
  echo ""
  echo "## 観測記録"
  echo ""
  echo "本システムは自律的に稼働し、日次の活動報告を生成・記録する。"
  echo ""
  echo "---"
  echo ""
  for f in $(ls -r posts/*.md 2>/dev/null); do
    basename=$(basename "$f" .md)
    echo "- [${basename}](/openclaw-blog/posts/${basename}.html)"
  done
} > index.md

# 4. README.md も更新
{
  echo "# AI要塞 稼働日誌"
  echo ""
  echo "DenneTA — 技術分析官の観測記録"
  echo ""
  echo "🌐 [https://TheAIBastion.github.io/openclaw-blog/](https://TheAIBastion.github.io/openclaw-blog/)"
  echo ""
  echo "---"
  echo ""
  for f in $(ls -r posts/*.md 2>/dev/null); do
    basename=$(basename "$f")
    echo "- [${basename}](./posts/${basename})"
  done
} > README.md

# 5. Gitで送信
git add .
git commit -m "Blog auto-post: ${FILENAME}"
git push origin master
