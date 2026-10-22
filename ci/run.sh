#!/usr/bin/env bash
set -euo pipefail

tap_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$tap_root"
brew readall --syntax --no-simulate javisoto/tap
brew style Formula/wacrawl.rb

# Use Homebrew's actual unpack/patch path, without changing installed packages.
tap_scratch="$(mktemp -d "${TMPDIR:-/tmp}/homebrew-tap-ci.XXXXXX")"
trap 'rm -rf -- "$tap_scratch"' EXIT
brew unpack --patch --destdir "$tap_scratch" javisoto/tap/wacrawl
cd "$tap_scratch/wacrawl-0.4.3"
export GOWORK=off
go test -count=1 ./internal/whatsappdb
go build -trimpath -ldflags '-s -w -X github.com/openclaw/wacrawl/internal/cli.version=0.4.3+codex.1' -o "$tap_scratch/wacrawl" ./cmd/wacrawl
[[ "$("$tap_scratch/wacrawl" --version)" == *0.4.3+codex.1* ]]
