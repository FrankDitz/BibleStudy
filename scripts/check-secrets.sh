#!/bin/sh
set -eu

if git ls-files --error-unmatch Config/Secrets.xcconfig >/dev/null 2>&1; then
    echo "Config/Secrets.xcconfig must never be tracked" >&2
    exit 1
fi

matches=$(git grep -nE '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{20,}|(YVP_APP_KEY|API_BIBLE_KEY)[[:space:]]*=[[:space:]]*[A-Za-z0-9+/=_-]{20,})' -- ':!Config/Secrets.example.xcconfig' ':!scripts/check-secrets.sh' || true)

if [ -n "$matches" ]; then
    echo "possible committed secret:" >&2
    printf '%s\n' "$matches" >&2
    exit 1
fi

echo "tracked secret scan passed"
