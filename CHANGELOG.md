# Changelog

All notable changes to **setup-solr-action** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2026-06-29

### 🚀 Features

- Add caching to the `setup-node` action ([#47](https://github.com/DhavalGojiya/setup-solr-action/pull/47))
- Add Node.js 24 LTS support to the action ([#46](https://github.com/DhavalGojiya/setup-solr-action/pull/46))
- Add Solr 10 support to the action ([#42](https://github.com/DhavalGojiya/setup-solr-action/pull/42))

### 🐛 Bug Fixes

- Fix typos discovered by codespell in Solr schema files ([#40](https://github.com/DhavalGojiya/setup-solr-action/pull/40))

### 📝 Documentation

- Clarify Node.js version setup and commit conventions in CONTRIBUTING ([#53](https://github.com/DhavalGojiya/setup-solr-action/pull/53))
- Add `CHANGELOG.md` ([#51](https://github.com/DhavalGojiya/setup-solr-action/pull/51))

### 🧰 Maintenance

- Refactor CI workflows for improved structure and security ([#56](https://github.com/DhavalGojiya/setup-solr-action/pull/56))
- Bump `actions/checkout` in the github-actions group ([#55](https://github.com/DhavalGojiya/setup-solr-action/pull/55))
- Add shellcheck, actionlint, and yamlfmt pre-commit hooks ([#54](https://github.com/DhavalGojiya/setup-solr-action/pull/54))
- Add mdformat pre-commit hook and reformat markdown ([#52](https://github.com/DhavalGojiya/setup-solr-action/pull/52))
- Update pre-commit hook versions ([#50](https://github.com/DhavalGojiya/setup-solr-action/pull/50))
- Add `.nvmrc` to pin Node version for contributors ([#49](https://github.com/DhavalGojiya/setup-solr-action/pull/49))
- Bump `actions/checkout` from 6.0.2 to 6.0.3 ([#48](https://github.com/DhavalGojiya/setup-solr-action/pull/48))
- Update all dependencies to latest compatible versions ([#45](https://github.com/DhavalGojiya/setup-solr-action/pull/45))
- Move Solr test config fixtures to `tests/solr_configs` ([#44](https://github.com/DhavalGojiya/setup-solr-action/pull/44))
- Pin GitHub Actions to specific commit SHAs in CI workflows ([#43](https://github.com/DhavalGojiya/setup-solr-action/pull/43))
- Update GitHub Actions workflows based on Zizmor security reports ([#41](https://github.com/DhavalGojiya/setup-solr-action/pull/41))
- Add Biome and shfmt pre-commit hooks ([#39](https://github.com/DhavalGojiya/setup-solr-action/pull/39))
- Add pre-commit to run standard hooks plus codespell ([#38](https://github.com/DhavalGojiya/setup-solr-action/pull/38))
- Add funding support file to the project

## [1.1.0] - 2025-11-26

### 🚀 Features

- Add Solr 9 support to the GitHub Actions test matrix ([#35](https://github.com/DhavalGojiya/setup-solr-action/pull/35))

### 🧰 Maintenance

- Add debug logging for Solr version resolution in setup script ([#36](https://github.com/DhavalGojiya/setup-solr-action/pull/36))
- Bump `actions/checkout` from 5 to 6 ([#32](https://github.com/DhavalGojiya/setup-solr-action/pull/32))

## [1.0.4] - 2025-11-01

### 🚀 Features

- Add Biome CI check to GitHub Actions workflow ([#30](https://github.com/DhavalGojiya/setup-solr-action/pull/30))
- Add CODEOWNERS file to the project ([#27](https://github.com/DhavalGojiya/setup-solr-action/pull/27))

### 🐛 Bug Fixes

- Resolve a bug where tsup did not include non-dev dependencies during the bundle build process ([#29](https://github.com/DhavalGojiya/setup-solr-action/pull/29))
- Exclude `state-helper.js` from the tsup build process ([#26](https://github.com/DhavalGojiya/setup-solr-action/pull/26))

### 📝 Documentation

- Use current Actions and Python in the README example ([#23](https://github.com/DhavalGojiya/setup-solr-action/pull/23))

### 🧰 Maintenance

- Keep GitHub Actions up to date with Dependabot ([#22](https://github.com/DhavalGojiya/setup-solr-action/pull/22))
- Bump `actions/setup-node` from 4 to 6 ([#24](https://github.com/DhavalGojiya/setup-solr-action/pull/24))

## [1.0.3] - 2025-10-08

### 🚀 Features

- Add branding for setup-solr-action ([#15](https://github.com/DhavalGojiya/setup-solr-action/pull/15))

### 📝 Documentation

- Update `package.json` description for the setup-solr-action project
- Improve comments in `src/index.js` for better readability ([#12](https://github.com/DhavalGojiya/setup-solr-action/pull/12))

### 🧰 Maintenance

- Add `SECURITY.md` file to the repository ([#14](https://github.com/DhavalGojiya/setup-solr-action/pull/14))
- Add Contributor Covenant Code of Conduct ([#13](https://github.com/DhavalGojiya/setup-solr-action/pull/13))

## [1.0.2] - 2025-09-18

### 🚀 Features

- Add Solr container cleanup logic to the GitHub Action ([#10](https://github.com/DhavalGojiya/setup-solr-action/pull/10))
- Add fail-fast `package-lock.json` sync check ([#8](https://github.com/DhavalGojiya/setup-solr-action/pull/8))

### 🧰 Maintenance

- Improve logger message visibility and formatting for clearer debugging ([#9](https://github.com/DhavalGojiya/setup-solr-action/pull/9))

## [1.0.1] - 2025-09-12

### 📝 Documentation

- Update README with documentation improvements ([#3](https://github.com/DhavalGojiya/setup-solr-action/pull/3))

### 🧰 Maintenance

- Change Solr action setup checkout to `@v1` inside `ci-release.yml` workflow ([#6](https://github.com/DhavalGojiya/setup-solr-action/pull/6))
- Improve CI/CD workflows and rename all workflows with a `ci` prefix ([#4](https://github.com/DhavalGojiya/setup-solr-action/pull/4))
- Add `.gitattributes` file to enforce LF line endings ([#5](https://github.com/DhavalGojiya/setup-solr-action/pull/5))

## [1.0.0] - 2025-09-07

### 🎉 Initial Release

- Apache Solr Action: core setup & custom configsets

### 🐛 Bug Fixes

- Correct package name to setup-solr-action ([#2](https://github.com/DhavalGojiya/setup-solr-action/pull/2))

### 📝 Documentation

- Fix typo in project name in the contributing file ([#1](https://github.com/DhavalGojiya/setup-solr-action/pull/1))

[1.0.0]: https://github.com/DhavalGojiya/setup-solr-action/releases/tag/v1.0.0
[1.0.1]: https://github.com/DhavalGojiya/setup-solr-action/compare/v1.0.0...v1.0.1
[1.0.2]: https://github.com/DhavalGojiya/setup-solr-action/compare/v1.0.1...v1.0.2
[1.0.3]: https://github.com/DhavalGojiya/setup-solr-action/compare/v1.0.2...v1.0.3
[1.0.4]: https://github.com/DhavalGojiya/setup-solr-action/compare/v1.0.3...v1.0.4
[1.1.0]: https://github.com/DhavalGojiya/setup-solr-action/compare/v1.0.4...v1.1.0
[1.2.0]: https://github.com/DhavalGojiya/setup-solr-action/compare/v1.1.0...v1.2.0
[unreleased]: https://github.com/DhavalGojiya/setup-solr-action/compare/v1.2.0...HEAD
