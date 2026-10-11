#!/bin/sh
set -eu

branch_name=${1:-}

if [ -z "$branch_name" ]; then
    echo "usage: $0 <branch-name>" >&2
    exit 2
fi

if [ "$branch_name" = "main" ]; then
    exit 0
fi

topic_pattern='^(feature|fix|hotfix|chore|docs|refactor|test)/([A-Z][A-Z0-9]+-[0-9]+-)?[a-z0-9]+(-[a-z0-9]+)*$'
release_pattern='^release/v[0-9]+\.[0-9]+\.[0-9]+$'

if printf '%s\n' "$branch_name" | grep -Eq "$topic_pattern|$release_pattern"; then
    exit 0
fi

echo "invalid branch name: $branch_name" >&2
echo "expected type/short-description or type/WORK-123-short-description" >&2
exit 1
