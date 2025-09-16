const core = require("@actions/core");
const exec = require("@actions/exec");
const path = require("node:path");

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

// Run the action
run();
