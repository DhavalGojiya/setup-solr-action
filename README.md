# ⚡ Setup Apache Solr (GitHub Action)

<p align="center">
  <img src="https://raw.githubusercontent.com/DhavalGojiya/setup-solr-action/main/assets/images/project-logo.png" width="90%" alt="Project Apache Solr Logo"/>
</p>

Easily spin up an [Apache Solr](https://solr.apache.org/) instance inside your **GitHub Actions CI** pipeline.
This action makes it simple to provision Solr during your tests or builds, without needing complex manual setup.

It will:

- ✅ Pull the specified Solr Docker image
- ✅ Start Solr on your chosen host port
- ✅ Create a Solr core with the name you provide
- ✅ Optionally copy custom configsets (`schema.xml`, `solrconfig.xml`, etc.)
- ✅ Simplifies Solr setup in CI
- ✅ Lets you focus on testing, not infrastructure

______________________________________________________________________

## 📑 Table of Contents

- [⚡ Setup Apache Solr (GitHub Action)](#-setup-apache-solr-github-action)
  - [📑 Table of Contents](#-table-of-contents)
  - [🚀 Usage](#-usage)
  - [⚙️ Inputs](#%EF%B8%8F-inputs)
  - [📂 Example: Custom Configset](#-example-custom-configset)
    - [How to Use in This Action](#how-to-use-in-this-action)
  - [🔎 Debugging & Logs](#-debugging--logs)
  - [🛠️ Example Workflow](#%EF%B8%8F-example-workflow)
  - [💡 Why use this action?](#-why-use-this-action)
  - [🧪 Testing](#-testing)
  - [🤝 Contributing](#-contributing)
  - [👨‍💻 About the Author](#%E2%80%8D-about-the-author)
  - [📜 License](#-license)

______________________________________________________________________

## 🚀 Usage

Add this step to your workflow for a **basic setup**:

```yaml
- name: Setup Apache Solr Infrastructure
  uses: dhavalgojiya/setup-solr-action@v1
  with:
    solr-version: "9.10.0"
    solr-core-name: "my_test_core"
```

Run Solr on a **different port**:

```yaml
- name: Setup Apache Solr Infrastructure
  uses: dhavalgojiya/setup-solr-action@v1
  with:
    solr-version: "9.10.0"
    solr-core-name: "my_test_core"
    solr-port: "9011"
```

Provide a **custom configset** (e.g., your own `schema.xml` and `solrconfig.xml`):

```yaml
- name: Setup Apache Solr Infrastructure
  uses: dhavalgojiya/setup-solr-action@v1
  with:
    solr-version: "9.10.0"
    solr-core-name: "my_test_core"
    solr-custom-configset-path: "solr_configs/" # Path must be relative to repo root
```

______________________________________________________________________

## ⚙️ Inputs

| Name                         | Required | Default | Description                                                                                              |
| ---------------------------- | -------- | ------- | -------------------------------------------------------------------------------------------------------- |
| `solr-version`               | ✅ Yes   | —       | The Solr Docker image version to use (e.g., `9.9.0`, `9.10.0`, `9.10.0-slim`).                           |
| `solr-core-name`             | ✅ Yes   | —       | The name of the Solr core to create.                                                                     |
| `solr-custom-configset-path` | ❌ No    | —       | Path to a folder containing your custom Solr configset (e.g., schema.xml, solrconfig.xml, synonyms.txt). |
| `solr-port`                  | ❌ No    | `8983`  | Host port on which Solr will be accessible (maps to container port `8983`).                              |

______________________________________________________________________

## 📂 Example: Custom Configset

If your project requires a specific Solr schema and configuration beyond the default setup, you can provide a **custom configset**.
A configset is a folder that contains all the configuration files Solr needs to define how documents are indexed and searched.

Typical files inside a custom configset include:

- **`schema.xml`** → Defines the structure of your Solr documents (fields, field types, analyzers, tokenizers).\
  Example: a `title` field as text, an `id` field as a unique key, or a `price` field as a float.

- **`solrconfig.xml`** → Controls Solr core behavior and request handling.\
  Example: enabling query handlers, faceting, caching strategies, or replication settings.

- **`synonyms.txt`** → Lists synonyms to improve search results.\
  Example: `Defense => Armed forces, national security`\
  Searching for "Defense" will also match documents containing "Armed forces" or "national security".

- Other optional files like **`stopwords.txt`**, **`protwords.txt`**, etc. depending on your project’s search needs.

______________________________________________________________________

### How to Use in This Action

1. Place your config files in a folder inside your repository, for example:

```
solr_configs/
├── schema.xml
├── solrconfig.xml
├── synonyms.txt
```

2. Pass the folder path to the action input `solr-custom-configset-path`:

```yaml
- name: Setup Apache Solr with custom configset
  uses: dhavalgojiya/setup-solr-action@v1
  with:
    solr-version: "9.10.0"
    solr-core-name: "my_project_core"
    solr-custom-configset-path: "solr_configs/" # relative to repo root
```

This ensures your **custom schema, configs, and search enhancements** are automatically copied into the Solr core during setup.
As a result, the Solr instance in your GitHub CI will behave just like your production or development Solr, making tests more realistic and reliable.

______________________________________________________________________

## 🔎 Debugging & Logs

The action provides clear and emoji-friendly logging to help you follow what’s happening:

```
🚀 Solr version: 9.10.0
🗂️ Solr Core name: test_core
🔌 Solr host port: 8983
🛠️ Solr Custom configset path: /home/runner/work/<REPO>/<REPO>/solr_configs
┌───────────────────────────────────────────────────────
│ ✔ Solr version resolved
│ 🔍 DEBUG: Solr full version     → [9.10.0]
│ 🔍 DEBUG: Solr major version    → [9]
└───────────────────────────────────────────────────────
⏳ Waiting for Solr core [test_core] to become healthy...
✅ Solr core [test_core] is healthy!
```

If Solr fails to become healthy within **30 seconds** (configurable by retry logic in the script), the action will stop and exit with an error.
This ensures your CI doesn’t hang indefinitely.

______________________________________________________________________

## 🛠️ Example Workflow

Here’s a complete example workflow that:

1. Sets up Solr in your workflow using this action.
2. Runs Python tests (`pytest`).

```yaml
name: Example Workflow with Solr

on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Setup Apache Solr Infrastructure
        uses: dhavalgojiya/setup-solr-action@v1
        with:
          solr-version: "9.10.0"
          solr-core-name: "products_core"
          solr-custom-configset-path: "solr_configs/"

      - name: Setup Python
        uses: actions/setup-python@v6
        with:
          python-version: "3.x"

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run tests  # Solr is available on host port 8983
        run: pytest -v products/tests/test_solr_product_apis.py
```

______________________________________________________________________

## 💡 Why use this action?

- No need to manually install or configure Solr on CI runners.
- Fully **Docker-based**: reliable, reproducible environments.
- Works seamlessly with your own **custom Solr schemas/configsets**.
- Great for integration tests that depend on a running Solr core.

______________________________________________________________________

## 🧪 Testing

To test this GitHub Action locally, run:

```bash
npm run act
```

This will simulate your workflow on your local machine using [act](https://github.com/nektos/act).

______________________________________________________________________

## 🤝 Contributing

Want to improve this project? Contributions are welcome!
Please check out the [Contributing Guide](./CONTRIBUTING.md) for details.

______________________________________________________________________

## 👨‍💻 About the Author

Hi, I’m **Dhaval Gojiya** — a passionate **Software Engineer** and also a **Farmer** 🌱.
I love building open-source tools that simplify workflows, while staying curious and grounded in both tech and nature.

______________________________________________________________________

## 📜 License

This project is licensed under the [MIT License](./LICENSE).

<p align="center">
  <img src="https://img.shields.io/badge/Made%20by-Dhaval%20Gojiya-bluered?style=for-the-badge&logo=github" alt="Made by Dhaval Gojiya"/>
</p>
