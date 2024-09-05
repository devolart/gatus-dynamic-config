#!/bin/bash

# Set variables to use the current directory
CURRENT_DIR="$(pwd)"
GATUS_BINARY="$CURRENT_DIR/gatus"  # Gatus binary will be downloaded here
CONFIG_URL="${CONFIG_URL:-}"  # Make sure to set this environment variable before running the script
LOCAL_CONFIG="$CURRENT_DIR/config/config.yaml"  # Local config file will be stored here

# Create the config directory if it doesn't exist
mkdir -p "$(dirname "$LOCAL_CONFIG")"

# Function to check if necessary variables are set
check_variables() {
  if [ -z "$CONFIG_URL" ]; then
    echo "$(date '+%Y/%m/%d %H:%M:%S') [boot] Error: CONFIG_URL is not set. Please set the URL to the Gatus configuration file."
    exit 1
  fi
}

# Function to download Gatus binary if not found
download_gatus() {
  echo "$(date '+%Y/%m/%d %H:%M:%S') [boot] Gatus binary not found. Downloading..."
  curl -s -L -O https://github.com/devolart/gatus-dynamic-config/releases/download/1.0/gatus
  if [ ! -f "$GATUS_BINARY" ]; then
    echo "$(date '+%Y/%m/%d %H:%M:%S') [boot] Error: Failed to download Gatus binary."
    exit 1
  fi
  echo "$(date '+%Y/%m/%d %H:%M:%S') [boot] Gatus binary downloaded to $GATUS_BINARY."
}

# Function to start Gatus
start_gatus() {
  echo "$(date '+%Y/%m/%d %H:%M:%S') [boot] Starting Gatus..."
  chmod +x $GATUS_BINARY
  "$GATUS_BINARY"
}

# Run the variable check function
check_variables

# Check if Gatus binary exists, otherwise download it
if [ ! -x "$GATUS_BINARY" ]; then
  download_gatus
fi

# Initial configuration download and start Gatus
curl -s -o "$LOCAL_CONFIG" "${CONFIG_URL}?cache-bypass=$(date +%s)"
start_gatus
