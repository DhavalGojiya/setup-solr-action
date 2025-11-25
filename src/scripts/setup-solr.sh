#!/bin/bash
set -e # Exit immediately if any command fails.

# -------------------------------
# Input arguments
# -------------------------------
SOLR_VERSION="$1"               # Solr Docker image version (e.g., "8.9.0")
SOLR_CORE_NAME="$2"             # Name of the Solr core to create
SOLR_CUSTOM_CONFIGSET_PATH="$3" # Optional local config folder provided by user
SOLR_HOST_PORT="${4:-8983}"     # Local host port for Solr (default: 8983)

# -------------------------------
# Solr internal ports and container filesystem paths
# -------------------------------
SOLR_CONTAINER_PORT=8983
SOLR_SAMPLE_TECHPRODUCTS_CONFDIR="/opt/solr/server/solr/configsets/sample_techproducts_configs"
SOLR_CORES_BASE="/var/solr/data"
SOLR_CORE_HOME="$SOLR_CORES_BASE/$SOLR_CORE_NAME"
SOLR_CORE_CONF="$SOLR_CORE_HOME/conf"

# -----------------------------------------
# Step 1: Start Solr container
# -----------------------------------------
echo "🚀 Starting Solr container on host port $SOLR_HOST_PORT... ⏳"
docker run -d \
    -p $SOLR_HOST_PORT:$SOLR_CONTAINER_PORT \
    solr:$SOLR_VERSION solr-precreate "$SOLR_CORE_NAME" $SOLR_SAMPLE_TECHPRODUCTS_CONFDIR

# -----------------------------------------
# Step 2: Get running container ID
# -----------------------------------------
SOLR_CONTAINER=$(docker ps -f ancestor=solr:$SOLR_VERSION --format '{{.ID}}' | head -n1)

if [ -z "$SOLR_CONTAINER" ]; then
    echo "❌ No running Solr container found for solr:$SOLR_VERSION"
    exit 1
fi

# -----------------------------------------
# Step 3: Detect full Solr version (major.minor.patch)
# -----------------------------------------

# Starting from Solr 9.8+, the correct command to get the Solr version is `solr --version`
SOLR_VERSION_OUTPUT=$(docker exec "$SOLR_CONTAINER" solr --version 2>/dev/null || true)
SOLR_VERSION_FULL=$(echo "$SOLR_VERSION_OUTPUT" | grep -oP '\d+\.\d+\.\d+' || true)

# Fallback to the old Solr version checking style: `solr version`
if [ -z "$SOLR_VERSION_FULL" ]; then
    SOLR_VERSION_OUTPUT=$(docker exec "$SOLR_CONTAINER" solr version 2>/dev/null || true)
    SOLR_VERSION_FULL=$(echo "$SOLR_VERSION_OUTPUT" | grep -oP '\d+\.\d+\.\d+' || true)
fi

# Extract major only (e.g. 8, 9, 10)
SOLR_VERSION_MAJOR=$(echo "$SOLR_VERSION_FULL" | cut -d '.' -f 1)

if [ -n "$SOLR_VERSION_FULL" ]; then
    echo "┌───────────────────────────────────────────────────────"
    echo "│ ✔ Solr version resolved"
    echo "│ 🔍 DEBUG: Solr full version     → [$SOLR_VERSION_FULL]"
    echo "│ 🔍 DEBUG: Solr major version    → [$SOLR_VERSION_MAJOR]"
    echo "└───────────────────────────────────────────────────────"
else
    echo "┌──────────────────────────────────────────────"
    echo "│ ✖ Failed to resolve Solr version"
    echo "└──────────────────────────────────────────────"
fi

# -----------------------------------------
# Step 4: Save container ID into GitHub Actions state
# -----------------------------------------
if [ -n "$GITHUB_STATE" ]; then
    if echo "SOLR_CONTAINER=$SOLR_CONTAINER" >>"$GITHUB_STATE"; then
        echo "ℹ️ Saved Solr container ID to GITHUB_STATE: $SOLR_CONTAINER"
    else
        echo "⚠️ Failed to save Solr container ID to GITHUB_STATE"
    fi
fi

# -----------------------------------------
# Step 5: Wait for Solr core to become ready
# -----------------------------------------
SOLR_CORE_PING_URL="http://127.0.0.1:$SOLR_HOST_PORT/solr/$SOLR_CORE_NAME/admin/ping?wt=json"

echo "⏳ Waiting for Solr core [$SOLR_CORE_NAME] to become healthy..."

HEALTHCHECK_INTERVAL=5 # Seconds between retries
HEALTHCHECK_RETRIES=6  # Total retries (5s * 6 = 30s total)
CURRENT_RETRY=0

until curl -s "$SOLR_CORE_PING_URL" | grep -q 'OK'; do
    CURRENT_RETRY=$((CURRENT_RETRY + 1))
    if [ "$CURRENT_RETRY" -ge "$HEALTHCHECK_RETRIES" ]; then
        TOTAL_WAIT=$((HEALTHCHECK_INTERVAL * HEALTHCHECK_RETRIES))
        echo "❌ Solr core [$SOLR_CORE_NAME] did not become healthy after $TOTAL_WAIT seconds (ping timeout)"
        exit 1
    fi
    sleep "$HEALTHCHECK_INTERVAL"
done

echo "✅ Solr core [$SOLR_CORE_NAME] is healthy!"

# -----------------------------------------
# Step 6: Copy solr custom configs if provided
# -----------------------------------------
if [ -n "$SOLR_CUSTOM_CONFIGSET_PATH" ]; then
    echo "📦 Copying custom configs from '$SOLR_CUSTOM_CONFIGSET_PATH' to Solr core [$SOLR_CORE_NAME]... ⏳"

    docker cp "$SOLR_CUSTOM_CONFIGSET_PATH/." $SOLR_CONTAINER:$SOLR_CORE_CONF

    # Fix permissions to match Solr user inside the container
    docker exec -u root $SOLR_CONTAINER chown -R solr:solr $SOLR_CORE_HOME
    echo "✅ Custom configs copied to Solr core [$SOLR_CORE_NAME] successfully"
else
    echo "⚠️ No custom config path provided — skipping (optional step)"
fi

# -----------------------------------------
# Step 7: Reload the Solr core to pick up changes
# -----------------------------------------
SOLR_CORE_RELOAD_URL="http://127.0.0.1:$SOLR_HOST_PORT/solr/admin/cores?action=RELOAD&core=$SOLR_CORE_NAME"

echo "🔄 Reloading Solr core [$SOLR_CORE_NAME]... ⏳"
echo "   🌐 URL: '${SOLR_CORE_RELOAD_URL}'"

RESPONSE=$(curl -s -w "\n%{http_code}" "$SOLR_CORE_RELOAD_URL")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ Solr core [$SOLR_CORE_NAME] reloaded successfully (HTTP $HTTP_CODE)"
else
    echo "❌ Failed to reload Solr core [$SOLR_CORE_NAME] (HTTP $HTTP_CODE)"
    echo "$BODY"
    exit 1
fi

echo "✨ Solr setup completed successfully!"
