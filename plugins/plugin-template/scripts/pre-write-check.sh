#!/usr/bin/env bash
# Pre-write hook script — runs BEFORE Write/Edit tool calls
# Available environment variables:
#   $CLAUDE_PLUGIN_ROOT - path to this plugin's root directory
#   $TOOL_INPUT         - JSON string of tool input parameters
#   $TOOL_NAME          - name of the tool being used

echo "Pre-write check running for: $TOOL_NAME"

# Example: block writes to protected files
# FILE=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')
# if [[ "$FILE" == *".env"* ]]; then
#   echo '{"continue": false, "stopReason": "Cannot write to .env files"}'
#   exit 0
# fi
