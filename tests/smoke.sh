#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT

cat >"$temporary/.devtasks.toml" <<'TOML'
default = ["smoke"]

[tasks.smoke]
label = "Smoke"
command = ["sh", "-c", "sleep 0.05; echo smoke-ok"]
ready_after = 0.01
TOML

output=$(
    cd "$temporary"
    env \
        -u ZELLIJ \
        -u ZELLIJ_SESSION_NAME \
        -u ZELLIJ_PANE_ID \
        XDG_RUNTIME_DIR="$temporary/runtime" \
        "$root/devtasks" _run smoke
)

grep -q "smoke-ok" <<<"$output"
status=$(
    cd "$temporary"
    env \
        -u ZELLIJ \
        -u ZELLIJ_SESSION_NAME \
        XDG_RUNTIME_DIR="$temporary/runtime" \
        "$root/devtasks" status
)
grep -q "stopped  Smoke (exit 0)" <<<"$status"
printf 'devtasks smoke test passed\n'
