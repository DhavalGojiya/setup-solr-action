# 🤝 Contributing to setup-solr-action

First off, thank you for considering contributing to **setup-solr-action** 🎉.
Contributions, issues, and feature requests are welcome!

---

## 📑 Table of Contents

- [🤝 Contributing to setup-solr-action](#-contributing-to-setup-solr-action)
  - [📑 Table of Contents](#-table-of-contents)
  - [🛠️ Getting Started](#️-getting-started)
  - [🧹 Code Quality (Linting \& Formatting)](#-code-quality-linting--formatting)
  - [📦 Build](#-build)
  - [⚡ All-in-One Command](#-all-in-one-command)
  - [🧪 Testing Locally](#-testing-locally)
  - [📥 Submitting a Pull Request](#-submitting-a-pull-request)
  - [📜 Guidelines](#-guidelines)
  - [🙌 Thank You](#-thank-you)

---

## 🛠️ Getting Started

1. **Fork** this repository.
2. **Clone** your fork locally:

```bash
   git clone https://github.com/dhavalgojiya/setup-solr-action.git
   cd setup-solr-action
```

3. Install project dependencies:

   ```bash
   npm install
   ```

   This will set up all required packages defined in `package-lock.json` for development.

---

## 🧹 Code Quality (Linting & Formatting)

We use [Biome](https://biomejs.dev/) for linting and formatting, along with [shfmt](https://github.com/mvdan/sh) for shell scripts.

- Run linting & formatting checks:

  ```bash
  npm run check
  ```

  > This will automatically apply fixes for formatting/lint issues across the project.

- Format shell scripts (in `src/scripts/`):

  ```bash
  npm run format:sh
  ```

---

## 📦 Build

We use [tsup](https://tsup.egoist.dev/) to bundle the action.
This compiles the source code into a distributable format inside the **`dist/`** folder.

- Run build:

  ```bash
  npm run build
  ```

  After running this, the final output can be found in `dist/`.

---

## ⚡ All-in-One Command

For convenience, you can run everything (install → lint → format → build) with a single command:

```bash
npm run all
```

This ensures your environment is clean and ready for contribution.

---

## 🧪 Testing Locally

You can simulate the GitHub Action locally using [nektos/act](https://github.com/nektos/act):

```bash
npm run act
```

This will run the action in a local environment, useful before pushing changes.

---

## 📥 Submitting a Pull Request

1.  **Create a new branch from `main`** for your work (don’t work directly on `main`):

```bash
git checkout -b feature/add-xyz
git checkout -b fix/solr-port-issue
git checkout -b docs/improve-readme
```

> Branch names should follow the format: <br> > `feature/...` → new features <br> > `fix/...` → bug fixes <br> > `docs/...` → documentation updates

2. **Make your changes** and commit with a clear message:

   ```bash
   git commit -m "fix: correct Solr port mapping issue"
   ```

3. **Push your branch** to your fork:

   ```bash
   git push origin feature/add-xyz
   ```

4. **Open a Pull Request (PR)** against the `main` branch of this repository.

   In the PR description:

   - Link the related issue using `Fixes #<issue_number>` (if applicable).
   - Explain what your PR changes or adds.
   - If it’s a new feature, provide usage examples.
   - If possible, add/update tests to cover your changes.

---

## 📜 Guidelines

- Follow existing coding style and formatting.
- Keep commits clean and meaningful.
- Update documentation (README, comments) if you change behavior.
- Pull requests should be small and focused.

---

## 🙌 Thank You

Every contribution counts! Whether it's fixing a typo, improving documentation, or suggesting a new feature — we appreciate your effort 💙.
