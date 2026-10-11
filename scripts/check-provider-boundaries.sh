#!/bin/sh
set -eu

imports=$(git grep -n '^import YouVersionPlatform' -- BibleStudy ':!BibleStudy/Features/Bible/YouVersion/**' ':!BibleStudy/Infrastructure/Scripture/YouVersionScriptureAdapter.swift' || true)

if [ -n "$imports" ]; then
    echo "YouVersionPlatform import outside the approved adapter/reader boundary:" >&2
    printf '%s\n' "$imports" >&2
    exit 1
fi

echo "provider boundary check passed"
