#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl git gnutar gzip nodejs_24 prefetch-npm-deps

set -euo pipefail

version="${1:-0.9.24}"

repo_root="$(git rev-parse --show-toplevel)"
pkg_dir="$repo_root/flake/packages/agentmemory"

if [ ! -d "$pkg_dir" ]; then
  echo "error: package dir not found: $pkg_dir" >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

export npm_config_cache="$tmp/npm-cache"
export npm_config_audit=false
export npm_config_fund=false
export npm_config_ignore_scripts=true

echo "Fetching @agentmemory/agentmemory@$version..."

curl -fsSL \
  "https://registry.npmjs.org/@agentmemory/agentmemory/-/agentmemory-$version.tgz" \
  -o "$tmp/agentmemory.tgz"

mkdir "$tmp/src"

tar -xzf "$tmp/agentmemory.tgz" \
  -C "$tmp/src" \
  --strip-components=1

cd "$tmp/src"

echo "Generating package-lock.json..."

npm install \
  --package-lock-only \
  --legacy-peer-deps \
  --ignore-scripts \
  --no-audit \
  --no-fund

cp package-lock.json "$pkg_dir/npm-deps-lock.json"

echo
echo "Updated:"
echo "  $pkg_dir/npm-deps-lock.json"

echo
echo "New npmDepsHash:"
prefetch-npm-deps "$pkg_dir/npm-deps-lock.json"
