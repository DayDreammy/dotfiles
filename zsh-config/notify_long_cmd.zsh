# Auto notify for long-running commands over SSH
# Deps: curl, python3

# Only enable in SSH sessions
if [[ -z "$SSH_CONNECTION" && -z "$SSH_TTY" ]]; then
  return 0
fi

# Load secrets (avoid leaking into history)
[[ -f "$HOME/.config/notify/feishu.env" ]] && source "$HOME/.config/notify/feishu.env"

typeset -g NOTIFY_THRESHOLD=${NOTIFY_THRESHOLD:-60}   # seconds
typeset -g NOTIFY_DEBOUNCE=${NOTIFY_DEBOUNCE:-3}      # seconds
typeset -g __notify_cmd=""
typeset -g __notify_start=0
typeset -g __notify_last_sent=0

# Commands you usually don't want notifications for
typeset -ga NOTIFY_IGNORE_PREFIXES=(
  "cd" "ls" "pwd" "clear" "exit" "fg" "bg"
  "vim" "vi" "nano" "less" "more" "man"
  "top" "htop" "watch" "ssh" "tmux"
)

_notify_feishu_sign() {
  local ts="$1"
  python3 - <<'PY' "$ts" "$FEISHU_SECRET"
import base64, hmac, hashlib, sys
ts = sys.argv[1]
secret = sys.argv[2]
string_to_sign = f"{ts}\n{secret}".encode("utf-8")
sign = base64.b64encode(
    hmac.new(secret.encode("utf-8"), string_to_sign, hashlib.sha256).digest()
).decode("utf-8")
print(sign)
PY
}

_notify_feishu_post_text() {
  local text="$1"
  [[ -z "$FEISHU_WEBHOOK" ]] && return 0

  local now_ts
  now_ts=$(date +%s)

  # Debounce to avoid spam
  if (( now_ts - __notify_last_sent < NOTIFY_DEBOUNCE )); then
    return 0
  fi
  __notify_last_sent=$now_ts

  local payload
  if [[ -n "$FEISHU_SECRET" ]]; then
    local sign
    sign="$(_notify_feishu_sign "$now_ts")"
    payload=$(python3 - <<'PY' "$now_ts" "$sign" "$text"
import json, sys
ts, sign, text = sys.argv[1], sys.argv[2], sys.argv[3]
print(json.dumps({
  "timestamp": ts,
  "sign": sign,
  "msg_type": "text",
  "content": {"text": text},
}, ensure_ascii=False))
PY
)
  else
    payload=$(python3 - <<'PY' "$text"
import json, sys
text = sys.argv[1]
print(json.dumps({
  "msg_type": "text",
  "content": {"text": text},
}, ensure_ascii=False))
PY
)
  fi

  curl -fsS -m 3 \
    -H 'Content-Type: application/json' \
    -d "$payload" \
    "$FEISHU_WEBHOOK" >/dev/null 2>&1 || true
}

_notify_preexec() {
  __notify_start=$EPOCHSECONDS
  __notify_cmd="$1"
}

_notify_precmd() {
  local rc=$?
  local end=$EPOCHSECONDS
  local dur=$(( end - __notify_start ))
  local cmd="$__notify_cmd"

  # Reset for next command
  __notify_cmd=""
  __notify_start=0

  (( dur < NOTIFY_THRESHOLD )) && return 0
  [[ -z "$cmd" ]] && return 0

  local p
  for p in "${NOTIFY_IGNORE_PREFIXES[@]}"; do
    [[ "$cmd" == ${p}* ]] && return 0
  done

  local host="$(hostname -s)"
  local cwd="$PWD"

  if (( rc == 0 )); then
    _notify_feishu_post_text "✅ Done (${dur}s) @${host}\n${cwd}\n$cmd"
  else
    _notify_feishu_post_text "❌ Failed (rc=${rc}, ${dur}s) @${host}\n${cwd}\n$cmd"
  fi
}

# Hook into zsh preexec/precmd without clobbering other hooks
autoload -Uz add-zsh-hook 2>/dev/null
if typeset -f add-zsh-hook >/dev/null; then
  add-zsh-hook preexec _notify_preexec
  add-zsh-hook precmd _notify_precmd
fi

# If you frequently use pipelines and want failure if any segment fails:
# setopt pipefail
