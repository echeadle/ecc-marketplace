# Plugin Template Reference

A complete skeleton plugin demonstrating every Claude Code plugin capability.

## Directory Structure

```
plugin-template/
├── .claude-plugin/
│   └── plugin.json          ← Plugin manifest (all fields)
├── skills/
│   └── example-skill/
│       └── SKILL.md         ← User-invoked skill (/plugin:skill)
├── agents/
│   └── example-agent.md     ← Claude-invoked agent for sub-tasks
├── commands/
│   └── example-command.md   ← Slash command
├── hooks/
│   └── hooks.json           ← Event hooks (auto-loaded, NOT declared in plugin.json)
├── scripts/
│   ├── pre-write-check.sh   ← Hook script: runs before Write/Edit
│   └── post-write-format.sh ← Hook script: runs after Write/Edit
├── mcp-config.json          ← MCP server definitions
├── .lsp.json                ← LSP server configuration
└── styles/
    └── concise.md           ← Custom output style
```

## Component Reference

| Component | Purpose | How Invoked |
|-----------|---------|-------------|
| **Skills** | Prompt instructions for workflows | User types `/plugin:skill` |
| **Agents** | Specialized sub-agents | Claude invokes automatically |
| **Commands** | Short action-oriented prompts | User types `/plugin:command` |
| **Hooks** | Event handlers | Auto-triggered on events |
| **MCP Servers** | External tool/service connections | Available as tools to Claude |
| **LSP Servers** | Language server protocol for code intelligence | Auto-started for matching file types |
| **Output Styles** | Custom response formatting | User selects style |

## plugin.json — Complete Schema

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Brief plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/author/plugin",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": ["./commands/"],
  "agents": "./agents/",
  "skills": "./skills/",
  "mcpServers": "./mcp-config.json",
  "outputStyles": "./styles/",
  "lspServers": "./.lsp.json"
}
```

**Important:** Do NOT include `"hooks": "./hooks/hooks.json"` — that file is auto-loaded by convention. The `hooks` field is only for *additional* hook files beyond the default.

## Skills (skills/\<name\>/SKILL.md)

User-invoked with `/plugin-name:skill-name`. YAML frontmatter required.

```markdown
---
name: skill-name
description: What this skill does
---

Your prompt instructions here. Claude follows these when the skill is invoked.
```

## Agents (agents/\<name\>.md)

Claude invokes these automatically when it determines the agent's expertise is needed.

```markdown
---
name: agent-name
description: What this agent specializes in and when Claude should invoke it
---

Detailed system prompt describing the agent's role, expertise, and behavior.
```

## Commands (commands/\<name\>.md)

Similar to skills but typically shorter, action-oriented instructions.

```markdown
---
name: command-name
description: What this command does
---

Short action-oriented instructions.
```

## Hooks (hooks/hooks.json)

Auto-loaded from `hooks/hooks.json`. Respond to Claude Code lifecycle events.

### Available Event Types

| Event | When it fires |
|-------|---------------|
| `PreToolUse` | Before a tool call executes |
| `PostToolUse` | After a tool call completes |
| `PostToolUseFailure` | After a tool call fails |
| `Stop` | When Claude finishes a response |
| `UserPromptSubmit` | When the user submits a prompt |
| `PermissionRequest` | When Claude requests permission |

### Hook Types

| Type | Purpose |
|------|---------|
| `command` | Execute a shell command/script |
| `prompt` | Evaluate a prompt with an LLM |
| `agent` | Run an agentic verifier for complex checks |

### Example hooks.json

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Session ending'"
          }
        ]
      }
    ]
  }
}
```

### Hook Script Environment Variables

- `$CLAUDE_PLUGIN_ROOT` — path to the plugin's root directory
- `$TOOL_INPUT` — JSON string of tool input parameters
- `$TOOL_NAME` — name of the tool being used

### Hook Return Format

Scripts can return JSON to control Claude's behavior:

```json
{
  "continue": false,
  "stopReason": "Blocked: cannot write to .env files",
  "suppressOutput": true
}
```

## MCP Servers (mcp-config.json)

Connect Claude to external tools and services.

```json
{
  "mcpServers": {
    "server-name": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "DATA_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
      }
    },
    "npx-server": {
      "command": "npx",
      "args": ["@example/mcp-server", "--plugin-mode"],
      "cwd": "${CLAUDE_PLUGIN_ROOT}"
    }
  }
}
```

Can also be defined inline in `plugin.json` under the `mcpServers` key.

## LSP Servers (.lsp.json)

Provide language intelligence (autocomplete, diagnostics) for specific file types.

```json
{
  "language-name": {
    "command": "language-server-binary",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ext": "language-name"
    }
  }
}
```

Can also be defined inline in `plugin.json` under the `lspServers` key.

## Output Styles (styles/\<name\>.md)

Custom output formatting that users can select.

```markdown
---
name: style-name
description: What this style does
---

Instructions for how Claude should format its output.
```

## Marketplace vs Plugin Fields

| Field | Level | Purpose |
|-------|-------|---------|
| `owner` | Marketplace (`marketplace.json`) | Who curates the catalog |
| `author` | Plugin (`plugin.json`) | Who created the plugin |

These are independent — a marketplace can host plugins from many different authors.

## Adding to a Marketplace

1. Copy this template to `plugins/<your-plugin-name>/`
2. Edit all files to match your plugin's purpose
3. Add an entry to `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-plugin-name",
  "source": "./plugins/your-plugin-name",
  "description": "What your plugin does",
  "version": "1.0.0"
}
```

4. Run `./scripts/validate.sh` to verify consistency
5. Delete any components you don't need (e.g., remove `servers/` if no MCP servers)
