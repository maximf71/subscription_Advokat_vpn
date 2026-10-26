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
python3 - "$TMP" "$ROOT" <<'PY'
import base64
import re
import sys
from pathlib import Path
from urllib.parse import quote, unquote

raw = Path(sys.argv[1]).read_bytes().strip()
root = Path(sys.argv[2])
decoded = base64.b64decode(raw).decode("utf-8")

def reformat_remark(line: str) -> str:
    if "#" not in line:
        return line
    base, frag = line.split("#", 1)
    name = unquote(frag)

    def repl(m: re.Match[str]) -> str:
        y, mo, d = m.group(1), m.group(2), m.group(3)
        return f"Истекает: {d}.{mo}.{y}"

    new_name = re.sub(r"Истекает:\s*(\d{4})-(\d{2})-(\d{2})", repl, name)
    return base + "#" + quote(new_name, safe="")

out_lines = []
for line in decoded.splitlines():
    line = line.strip()
    if line:
        out_lines.append(reformat_remark(line))

new_decoded = "\n".join(out_lines) + "\n"
new_b64 = base64.b64encode(new_decoded.encode("utf-8")).decode("ascii") + "\n"
(root / "happ").write_text(new_b64)
(root / "subscription").write_text(new_b64)
(root / "links.txt").write_text(new_decoded)
print("updated happ/subscription/links.txt (date format DD.MM.YYYY)")
PY
rm -f "$TMP"
