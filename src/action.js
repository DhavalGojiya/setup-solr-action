const core = require("@actions/core");
const exec = require("@actions/exec");
const path = require("node:path");
const { IsPost } = require("./state-helper");

/**
 * Main function for the GitHub Action
 */
async function run() {
  try {
    // Get inputs from action.yml
    const solrVersion = core.getInput("solr-version", { required: true });
    const coreName = core.getInput("solr-core-name", { required: true });
    const confDir = core.getInput("solr-custom-configset-path"); // optional
    const solrPort = core.getInput("solr-port"); // optional

    // Resolve path to the bundled setup script
    const scriptPath = path.join(__dirname, "scripts", "setup-solr.sh");

    // Resolve workspace path and optional configset directory
    const workspace = process.env.GITHUB_WORKSPACE || process.cwd();
    const confPath = confDir ? path.resolve(workspace, confDir) : "";

    core.info("════════════════════════════════════════════");
    core.info(`🚀 Solr version: ${solrVersion}`);
    core.info(`🗂️ Solr Core name: ${coreName}`);
    core.info(`🔌 Solr host port: ${solrPort}`);
    if (confPath) core.info(`🛠️ Solr Custom configset path: ${confPath}`);
    core.info("════════════════════════════════════════════");

    // Execute the bash script with arguments
    // Arguments: <solr-version> <core-name> <configset-path> <port>
    await exec.exec("bash", [
      scriptPath,
      solrVersion,
      coreName,
      confPath,
      solrPort,
    ]);
  } catch (error) {
    core.setFailed(`⚠️ [Setup Solr Action] Error: ${error.message}`);
  }
}

async function cleanup() {
  try {
    const containerId = core.getState("SOLR_CONTAINER");

    core.info(
      "| -------------------- 🧹 Solr Container Cleanup (setup-solr-action) -------------------",
    );

    if (!containerId) {
      core.info(
        "| ⚠️ No Solr container ID found in `GITHUB_STATE`. Skipping cleanup.",
      );
      core.info(
        "| --------------------------------------------------------------------------------------",
      );
      return;
    }

    core.info(
      `| ℹ️  Found Solr container '${containerId}' created by this action (setup-solr-action)`,
    );

    core.info(`| 🗑️  Removing container... ⏳`);

    // Stop and remove the Solr container along with its volumes
    await exec.exec("docker", ["rm", "-f", "-v", containerId]);

    core.info(`| ✅  Solr Container '${containerId}' removed successfully`);
    core.info(
      "| ---------------------------------------------------------------------------------------",
    );
  } catch (error) {
    core.warning(
      `| ❌ Failed to cleanup container: ${error?.message ?? error}`,
    );
  }
}

// Main
if (!IsPost) {
  run();
}
// Post
else {
  cleanup();
}
