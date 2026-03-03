#!/usr/bin/env bash
# Validates marketplace and plugin metadata for consistency.
# Usage: ./scripts/validate.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE="$ROOT/.claude-plugin/marketplace.json"
ERRORS=0

red()   { printf '\033[1;31m%s\033[0m\n' "$*"; }
green() { printf '\033[1;32m%s\033[0m\n' "$*"; }
info()  { printf '  %s\n' "$*"; }

error() {
  red "ERROR: $*"
  ERRORS=$((ERRORS + 1))
}

echo "Validating marketplace: $MARKETPLACE"
echo

# Check marketplace.json exists
if [ ! -f "$MARKETPLACE" ]; then
  error "marketplace.json not found at $MARKETPLACE"
  exit 1
fi

# Validate marketplace.json is valid JSON
if ! jq empty "$MARKETPLACE" 2>/dev/null; then
  error "marketplace.json is not valid JSON"
  exit 1
fi

MARKETPLACE_NAME=$(jq -r '.name' "$MARKETPLACE")
MARKETPLACE_AUTHOR=$(jq -r '.author.name' "$MARKETPLACE")
MARKETPLACE_LICENSE=$(jq -r '.metadata.license // empty' "$MARKETPLACE")

echo "Marketplace: $MARKETPLACE_NAME"
echo "Author: $MARKETPLACE_AUTHOR"
echo

# Iterate over each plugin entry in marketplace.json
PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE")
for i in $(seq 0 $((PLUGIN_COUNT - 1))); do
  PLUGIN_NAME=$(jq -r ".plugins[$i].name" "$MARKETPLACE")
  PLUGIN_SOURCE=$(jq -r ".plugins[$i].source" "$MARKETPLACE")
  PLUGIN_VERSION=$(jq -r ".plugins[$i].version" "$MARKETPLACE")
  PLUGIN_DIR="$ROOT/$PLUGIN_SOURCE"
  PLUGIN_JSON="$PLUGIN_DIR/.claude-plugin/plugin.json"

  echo "--- Plugin: $PLUGIN_NAME ---"

  # Check plugin directory exists
  if [ ! -d "$PLUGIN_DIR" ]; then
    error "[$PLUGIN_NAME] Plugin directory not found: $PLUGIN_DIR"
    continue
  fi

  # Check plugin.json exists and is valid JSON
  if [ ! -f "$PLUGIN_JSON" ]; then
    error "[$PLUGIN_NAME] plugin.json not found at $PLUGIN_JSON"
    continue
  fi

  if ! jq empty "$PLUGIN_JSON" 2>/dev/null; then
    error "[$PLUGIN_NAME] plugin.json is not valid JSON"
    continue
  fi

  # Read plugin.json fields
  PJ_NAME=$(jq -r '.name' "$PLUGIN_JSON")
  PJ_VERSION=$(jq -r '.version' "$PLUGIN_JSON")
  PJ_AUTHOR=$(jq -r '.author.name // empty' "$PLUGIN_JSON")
  PJ_LICENSE=$(jq -r '.license // empty' "$PLUGIN_JSON")

  # Check name matches
  if [ "$PJ_NAME" != "$PLUGIN_NAME" ]; then
    error "[$PLUGIN_NAME] Name mismatch: marketplace says '$PLUGIN_NAME', plugin.json says '$PJ_NAME'"
  else
    info "Name: OK"
  fi

  # Check version matches
  if [ "$PJ_VERSION" != "$PLUGIN_VERSION" ]; then
    error "[$PLUGIN_NAME] Version mismatch: marketplace says '$PLUGIN_VERSION', plugin.json says '$PJ_VERSION'"
  else
    info "Version: OK ($PJ_VERSION)"
  fi

  # Check author matches marketplace author
  if [ -n "$PJ_AUTHOR" ] && [ "$PJ_AUTHOR" != "$MARKETPLACE_AUTHOR" ]; then
    error "[$PLUGIN_NAME] Author mismatch: marketplace says '$MARKETPLACE_AUTHOR', plugin.json says '$PJ_AUTHOR'"
  else
    info "Author: OK"
  fi

  # Check license matches marketplace license
  if [ -n "$MARKETPLACE_LICENSE" ] && [ -n "$PJ_LICENSE" ] && [ "$PJ_LICENSE" != "$MARKETPLACE_LICENSE" ]; then
    error "[$PLUGIN_NAME] License mismatch: marketplace says '$MARKETPLACE_LICENSE', plugin.json says '$PJ_LICENSE'"
  else
    info "License: OK"
  fi

  # Check that at least one skill exists
  SKILLS_DIR="$PLUGIN_DIR/skills"
  if [ ! -d "$SKILLS_DIR" ]; then
    error "[$PLUGIN_NAME] No skills/ directory found"
  else
    SKILL_COUNT=$(find "$SKILLS_DIR" -name "SKILL.md" | wc -l)
    if [ "$SKILL_COUNT" -eq 0 ]; then
      error "[$PLUGIN_NAME] No SKILL.md files found in skills/"
    else
      info "Skills: $SKILL_COUNT found"
    fi
  fi

  echo
done

# Summary
echo "========================="
if [ "$ERRORS" -eq 0 ]; then
  green "Validation passed with no errors."
else
  red "Validation found $ERRORS error(s)."
  exit 1
fi
