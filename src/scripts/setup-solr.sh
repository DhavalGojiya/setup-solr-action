#!/bin/bash
set -e # Exit immediately if any command fails.

# -------------------------------
# Arguments
# -------------------------------
SOLR_VERSION="$1"               # Solr Docker image version (e.g., "8.9.0")
SOLR_CORE_NAME="$2"             # Name of the Solr core to create
SOLR_CUSTOM_CONFIGSET_PATH="$3" # Optional local config folder provided by user
SOLR_HOST_PORT="${4:-8983}"     # Local host port for Solr (default: 8983)
SOLR_CONTAINER_PORT=8983        # Port inside the container

# Default Solr sample config set path
SOLR_SAMPLE_TECHPRODUCTS_CONFDIR="/opt/solr/server/solr/configsets/sample_techproducts_configs"

# Destination inside the container for Solr core config files
CONTAINER_CONFDIR="/var/solr/data/$SOLR_CORE_NAME/conf"

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
# Step 3: Wait for Solr core to become ready
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
# Step 4: Copy solr custom configs if provided
# -----------------------------------------
if [ -n "$SOLR_CUSTOM_CONFIGSET_PATH" ]; then
    echo "📦 Copying custom configs from '$SOLR_CUSTOM_CONFIGSET_PATH' to Solr core [$SOLR_CORE_NAME]... ⏳"

    docker cp "$SOLR_CUSTOM_CONFIGSET_PATH/." $SOLR_CONTAINER:$CONTAINER_CONFDIR

    # Fix permissions to match Solr user inside the container
    docker exec -u root $SOLR_CONTAINER chown -R solr:solr /var/solr/data/$SOLR_CORE_NAME
    echo "✅ Custom configs copied to Solr core [$SOLR_CORE_NAME] successfully"
else
    echo "⚠️ Skipping custom configs: Variable 'solr-custom-configset-path' is not set"
fi

# -----------------------------------------
# Step 5: Reload the Solr core to pick up changes
# -----------------------------------------
SOLR_CORE_RELOAD_URL="http://127.0.0.1:$SOLR_HOST_PORT/solr/admin/cores?action=RELOAD&core=$SOLR_CORE_NAME"

echo "🔄 Reloading Solr core [$SOLR_CORE_NAME]... ⏳"
echo "   🌐 URL: $SOLR_CORE_RELOAD_URL"

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
