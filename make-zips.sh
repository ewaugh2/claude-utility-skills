#!/usr/bin/env bash
# Build one uploadable zip per skill into dist/.
# Each zip contains the skill folder at its root, which is what the
# Claude app's skill uploader expects.
set -euo pipefail

cd "$(dirname "$0")"
rm -rf dist
mkdir -p dist

for dir in skills/*/; do
  name="$(basename "$dir")"
  ( cd skills && zip -qr "../dist/${name}.zip" "$name" -x '*.DS_Store' )
  printf '%-28s -> dist/%s.zip\n' "$name" "$name"
done

echo
echo "Upload these in the Claude app: Settings -> Capabilities -> Skills"
