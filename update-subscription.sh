#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
URL="$(tr -d '[:space:]' < "$ROOT/SOURCE_URL.txt")"
HWID="${HWID:-00000000-0000-0000-0000-000000000001}"
TMP="$(mktemp)"
curl -sk --fail --max-time 30 \
  -A "Happ/3.0.0" \
  -H "x-hwid: ${HWID}" \
  -o "$TMP" \
  "$URL"
# normalize to single trailing newline
python3 - "$TMP" "$ROOT" <<'PY'
import sys
from pathlib import Path
raw = Path(sys.argv[1]).read_bytes().strip() + b"\n"
root = Path(sys.argv[2])
(root / "happ").write_bytes(raw)
(root / "subscription").write_bytes(raw)
import base64
(root / "links.txt").write_bytes(base64.b64decode(raw) + (b"" if base64.b64decode(raw).endswith(b"\n") else b"\n"))
print("updated happ/subscription/links.txt")
PY
rm -f "$TMP"
