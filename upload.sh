#!/bin/bash
set -euo pipefail

# =========================================================
# Load configuration (optional)
# =========================================================
if [[ -f ".env" ]]; then
    set -o allexport
    source .env
    set +o allexport
fi

# =========================================================
# Requirements
# =========================================================
command -v curl >/dev/null || {
    echo "Error: curl is not installed."
    exit 1
}

command -v jq >/dev/null || {
    echo "Error: jq is not installed."
    exit 1
}

# =========================================================
# Usage
# =========================================================
if [[ $# -eq 0 ]]; then
    cat <<EOF
Usage:
  ./upload.sh <file>
  ./upload.sh <file1> <file2> ...
  ./upload.sh *.zip
EOF
    exit 1
fi

BOT_URL=""
if [[ -n "${BOT_TOKEN:-}" && -n "${CHAT_ID:-}" ]]; then
    BOT_URL="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
fi

UPLOADED=0

for FILE in "$@"; do
    if [[ ! -f "$FILE" ]]; then
        echo "Skipping '$FILE' (not found)"
        echo
        continue
    fi

    NAME=$(basename "$FILE")
    SIZE=$(du -h "$FILE" | awk '{print $1}')

    echo "=================================================="
    echo "📁 $NAME"
    echo "📦 $SIZE"
    echo
    echo "⬆️ Uploading to GoFile..."

    RESP=$(curl --progress-bar -F "file=@${FILE}" "https://upload.gofile.io/uploadfile")
    LINK=$(echo "$RESP" | jq -r '.data.downloadPage // empty')

    if [[ -z "$LINK" ]]; then
        echo
        echo "❌ Upload failed."
        echo
        continue
    fi

    echo
    echo "✅ Upload Complete!"
    echo "🔗 $LINK"

    if [[ -n "$BOT_URL" ]]; then
        curl -s -X POST "$BOT_URL" \
            -d chat_id="$CHAT_ID" \
            -d parse_mode="Markdown" \
            -d disable_web_page_preview="true" \
            -d text="✅ *Upload Complete*

📁 [${NAME}](${LINK})
📦 ${SIZE}" >/dev/null

        echo "📨 Telegram notification sent."
    else
        echo "ℹ️ Telegram not configured. Skipping notification."
    fi

    echo
    ((UPLOADED++))
done

echo "=================================================="
echo "Uploaded ${UPLOADED} file(s)."
