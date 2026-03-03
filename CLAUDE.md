# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code plugin marketplace — a Git-based catalog that distributes plugins (each containing skills) for Claude Code. The marketplace itself is defined by `.claude-plugin/marketplace.json` and individual plugins live under `plugins/`.

## Key Commands

```bash
# Validate marketplace and plugin metadata consistency
./scripts/validate.sh

# Test a single plugin locally
claude --plugin-dir ./plugins/review-plugin

# Test the full marketplace locally
/plugin marketplace add ./
/plugin install review-plugin@ecc-marketplace
```

## Architecture

**Marketplace manifest** (`.claude-plugin/marketplace.json`): Top-level catalog listing all plugins with name, source path, description, and version. Author and license are defined at the marketplace level.

**Plugin manifest** (`plugins/<name>/.claude-plugin/plugin.json`): Per-plugin metadata. Name, version, author, and license must match the marketplace manifest — the validation script enforces this.

**Skills** (`plugins/<name>/skills/<skill-name>/SKILL.md`): YAML frontmatter (`name`, `description`) followed by the prompt instructions Claude receives when the skill is invoked. Each plugin must have at least one skill.

**Validation** (`scripts/validate.sh`): Bash script requiring `jq`. Checks JSON validity, cross-references names/versions/authors/licenses between marketplace and plugin manifests, and verifies skills exist.

## Adding a New Plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` and `plugins/<name>/skills/<skill>/SKILL.md`
2. Add a corresponding entry to `.claude-plugin/marketplace.json` under `plugins[]`
3. Run `./scripts/validate.sh` to verify consistency
4. Author name and license must match the marketplace-level values

## Conventions

- All metadata fields (name, version, author, license) must be consistent between marketplace.json and each plugin.json
- Plugin source paths in marketplace.json use `./plugins/<name>` format
- Skills are invoked as `/plugin-name:skill-name`
- Planning docs in `Planning/` are gitignored reference material, not part of the distributed marketplace

**IMPORTANT** claude code does not push commits to repositories properly.
- Instead of claude push
1. Find out what branch is being used
2. use the command  "git push <current branch>"
