# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Homebrew tap (`mherod/homebrew-tap`) containing two formulas:
- **get-cookie** — Node.js CLI for querying local Chrome cookies
- **resharkercli** — Git/Jira CLI built with Kotlin/Native and JVM

## Build System

Gradle (Kotlin DSL) automates the full bottle lifecycle. Key tasks:

```bash
./gradlew brewBottlePublish          # Full pipeline: build, bottle, upload, edit formula, commit
./gradlew brewInstallBuildBottle<Name>  # brew install --build-bottle for a formula
./gradlew brewBottle<Name>           # Create bottle tarball
./gradlew brewBottleUpload<Name>     # Upload bottle to GitHub release via gh CLI
```

`<Name>` is the capitalized formula name (e.g., `GetCookie`, `Resharkercli`).

The build dynamically discovers all `.rb` files in `Formula/`, extracts version strings, and generates per-formula task chains. After bottling, it rewrites the formula file to add new `sha256` bottle entries and auto-commits.

## Formula Files

Located in `Formula/`. Each is a standard Homebrew Ruby formula. Versions are defined as `VERSION` constants at the top of each file. URLs point to GitHub repos under `mherod/`.

## Dependencies

- **Gradle** with parallel builds and caching enabled (`gradle.properties`)
- **SDKMAN** for JDK/Kotlin toolchain (`install-sdkman-tools.sh` reads `.sdkmanrc`)
- **gh CLI** for uploading bottles to GitHub Releases
- **Homebrew** for `brew install`, `brew bottle` commands
