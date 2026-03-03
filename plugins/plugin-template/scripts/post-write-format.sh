#!/usr/bin/env bash
# Post-write hook script — runs AFTER Write/Edit tool calls
# Available environment variables:
#   $CLAUDE_PLUGIN_ROOT - path to this plugin's root directory
#   $TOOL_INPUT         - JSON string of tool input parameters
#   $TOOL_NAME          - name of the tool being used

echo "Post-write hook running for: $TOOL_NAME"

# Example: auto-format the written file
# FILE=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')
# if [[ "$FILE" == *.py ]]; then
#   black "$FILE" 2>/dev/null
# elif [[ "$FILE" == *.js || "$FILE" == *.ts ]]; then
#   npx prettier --write "$FILE" 2>/dev/null
# fi
