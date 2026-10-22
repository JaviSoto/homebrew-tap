# homebrew-tap

Homebrew tap for `JaviSoto/*` tools.

## Install

```bash
brew tap JaviSoto/tap
```

## Tools

- `copilot-money-cli`: `brew install copilot-money-cli`
- `apple-notes-cli`: `brew install javisoto/tap/apple-notes-cli`
- `wacrawl`: `brew install javisoto/tap/wacrawl`

## WhatsApp reader patch

The `wacrawl` formula builds upstream 0.4.3 at commit
`05c5b472819d411beff6e3a941229cd9785acee2` with one source patch. WhatsApp
stores opaque image/video metadata in `ZVCARDNAME`; upstream was displaying it
as a caption. Only contact cards may use that field as a display-name fallback.
Real captions and document titles are preserved. The formula embeds the patch
and synthetic import regression, and builds as `0.4.3+codex.1`.

On JaviMini, use this formula as the sole installed reader. When switching from
the upstream tap, remove only its binary package first, preserving the local
archive and WhatsApp data:

```bash
HOMEBREW_NO_AUTOREMOVE=1 HOMEBREW_NO_INSTALL_CLEANUP=1 brew uninstall openclaw/tap/wacrawl
HOMEBREW_NO_INSTALL_CLEANUP=1 brew install --build-from-source javisoto/tap/wacrawl
brew test javisoto/tap/wacrawl
wacrawl --version
wacrawl doctor
wacrawl import
```

`mise run ci` checks formula syntax/style, applies the embedded patch through
Homebrew, runs the WhatsApp import tests, and builds/verifies the CLI. It reads
no personal WhatsApp data. `brew reinstall --build-from-source
javisoto/tap/wacrawl` rebuilds the maintained recipe. The patch only affects new
imports; historical app projections require a revision-checked update of the
specific affected message labels. Never reset cursors or recreate messages.

Remove this patch and return to the upstream formula after an upstream release
passes the same media/contact/document regressions. Reverting to upstream 0.4.3
restores the caption bug; it does not roll back or delete the local archive.
