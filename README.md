# ecc-marketplace

A Claude Code plugin marketplace by Edward Cheadle.

## Structure

```
ecc-marketplace/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace catalog
├── plugins/
│   └── review-plugin/
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin manifest
│       └── skills/
│           └── review/
│               └── SKILL.md      # /review-plugin:review skill
```

## Testing locally

### Test a single plugin directly

```bash
claude --plugin-dir ./plugins/review-plugin
```

Then use the skill:

```
/review-plugin:review
```

### Test the full marketplace

From within Claude Code:

```
/plugin marketplace add ./
/plugin install review-plugin@ecc-marketplace
```

### Validate the marketplace

Run the included validation script to check metadata consistency:

```bash
./scripts/validate.sh
```

Or use the Claude Code built-in validator:

```bash
claude plugin validate .
```

## Sharing

Push this repo to GitHub, then others can add it:

```
/plugin marketplace add your-username/ecc-marketplace
```

Users install individual plugins with:

```
/plugin install review-plugin@ecc-marketplace
```

Users can update their local copy with:

```
/plugin marketplace update
```

## Adding a new plugin

A **plugin template** is available at [`plugins/plugin-template/`](plugins/plugin-template/) with a complete reference guide in [`PLUGIN_TEMPLATE.md`](plugins/plugin-template/PLUGIN_TEMPLATE.md). It documents every plugin capability — skills, agents, commands, hooks, MCP servers, LSP servers, and output styles — with examples and the full `plugin.json` schema. Copy the template as a starting point and remove the components you don't need.

Alternatively, you can create a plugin from scratch:

1. Create the plugin directory:

   ```bash
   mkdir -p plugins/my-plugin/.claude-plugin
   mkdir -p plugins/my-plugin/skills/my-skill
   ```

2. Create `plugins/my-plugin/.claude-plugin/plugin.json`:

   ```json
   {
     "name": "my-plugin",
     "description": "What the plugin does",
     "version": "1.0.0",
     "author": {
       "name": "Edward Cheadle"
     }
   }
   ```

3. Create `plugins/my-plugin/skills/my-skill/SKILL.md`:

   ```markdown
   ---
   description: What the skill does
   ---

   Instructions for Claude when this skill is invoked.
   ```

4. Add an entry to `.claude-plugin/marketplace.json`:

   ```json
   {
     "name": "my-plugin",
     "source": "./plugins/my-plugin",
     "description": "What the plugin does",
     "version": "1.0.0"
   }
   ```

## Available plugins

| Plugin | Description | Skill |
|:-------|:------------|:------|
| review-plugin | Quick code reviews | `/review-plugin:review` |
