# CLAUDE.md

Guidance for working in `mherod/homebrew-tap`.

## Repository purpose

This repository packages upstream projects as Homebrew formulae. It does not
contain the applications' source code.

- `Formula/get-cookie.rb` packages the supported `get-cookie` CLI.
- `Formula/resharkercli.rb` preserves metadata for the disabled legacy
  `resharkercli` formula.

## Formula conventions

- Use an immutable stable release URL and `sha256`.
- Declare the upstream license only when the upstream release contains or
  clearly declares it.
- Declare build and runtime dependencies accurately.
- Install executables into Homebrew's `bin` and add a meaningful, non-secret
  `test do` assertion.
- Never access real browser cookies or credentials from formula tests.
- Prefer current Homebrew helpers such as `std_npm_args` instead of importing
  legacy language modules directly.
- Do not restore custom bottle-block parsing or editing. Homebrew owns bottle
  metadata generation through `brew test-bot` and `brew pr-pull`.

## Validation

For a changed, supported formula, run these commands from Homebrew's local
`mherod/tap` checkout:

```bash
ruby -c Formula/get-cookie.rb
brew audit --strict --online --formula mherod/tap/get-cookie
brew install --build-from-source mherod/tap/get-cookie
brew test mherod/tap/get-cookie
```

Also validate workflow YAML whenever `.github/workflows/` changes.

## CI and bottle publication

- `.github/workflows/tests.yml` is the read-only pull-request test and bottle
  build workflow generated from Homebrew's `tap-new` template.
- `.github/workflows/publish.yml` is manually dispatched after review and runs
  `brew pr-pull` with an optional expected head SHA.
- Keep action references pinned to full commit SHAs and retain least-privilege
  job permissions.
- Do not add personal GitHub CLI configuration, direct pushes from test jobs,
  or a second release pipeline.

When refreshing workflows, render them from the current installed Homebrew
`brew tap-new` templates and review the resulting diff.
