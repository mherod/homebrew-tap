# mherod/homebrew-tap

Personal Homebrew formulae maintained by Matthew Herod.

## Install

Install a formula directly from the tap:

```bash
brew install mherod/tap/get-cookie
```

Homebrew adds the tap automatically. To add it without installing a formula:

```bash
brew tap mherod/tap
```

## Formulae

| Formula | Status | Description |
| --- | --- | --- |
| `get-cookie` | Supported | Queries cookies from Chrome, Firefox, Safari, and other browsers. |
| `resharkercli` | Disabled | Its upstream release uses an obsolete Intel-only Kotlin/Native toolchain and does not declare a license. |

## Contributing

Formula changes are validated on macOS and Linux with Homebrew's `brew test-bot`
workflow. From Homebrew's local `mherod/tap` checkout, run the relevant checks
before opening a pull request:

```bash
brew audit --strict --online --formula mherod/tap/get-cookie
brew install --build-from-source mherod/tap/get-cookie
brew test mherod/tap/get-cookie
```

Do not add bottle checksums by hand. Pull requests build bottles as workflow
artifacts. After review, publish them with the `brew pr-pull` workflow using the
pull request number and its reviewed head commit SHA.

## Release model

- Pull requests run read-only formula validation and bottle builds.
- Bottle publication is a separate, manually dispatched workflow.
- Publishing uses the repository-scoped GitHub Actions token; no personal
  GitHub CLI configuration or long-lived release credential is required.
- The publish workflow verifies an optional expected pull request head SHA
  before merging bottle metadata.

The workflow files are generated from Homebrew's current `brew tap-new`
templates.
