# Plugin Troubleshooting Guide

## "Plugins installed" count doesn't match installed plugins list

### Symptoms

- `/plugin` command shows N plugins installed
- Navigating to "Installed" tab shows fewer (or no) plugins
- Plugins appear in cache but not in the UI

### Root Cause

The plugin count may reflect cached plugin data, but the installed plugins list reads from `enabledPlugins` in your settings files. If plugins are cached but not listed in `enabledPlugins`, they won't appear in the installed list.

### Diagnosis Steps

#### 1. Check which plugins are enabled in your settings

Plugins can be enabled at three scopes. Check each one:

```bash
# User scope (global)
cat ~/.claude/settings.json | grep -A 20 enabledPlugins

# Project scope
cat .claude/settings.json | grep -A 20 enabledPlugins

# Local scope (gitignored)
cat .claude/settings.local.json | grep -A 20 enabledPlugins
```

Look for your plugin entries like `"plugin-name@marketplace-name": true`. If your plugins are missing from all three files, that's the problem.

#### 2. Verify the plugin cache

```bash
ls -la ~/.claude/plugins/cache/
```

This shows all cached marketplace directories. Each marketplace directory contains its plugin subdirectories. If your marketplace appears here but its plugins aren't in `enabledPlugins`, they're cached but not activated.

#### 3. Check for loading errors

In the `/plugin` UI, check the **Errors** tab for any plugin loading or parsing failures.

#### 4. Run the doctor command

```bash
/doctor
```

This will report any plugin-related issues.

### Fixes

#### Fix 1: Re-enable the plugin

If your plugin is cached but not in `enabledPlugins`, re-enable it:

```
/plugin enable plugin-name@marketplace-name
```

Or use the `/plugin` UI to toggle it on.

#### Fix 2: Clear cache and reinstall

If the cache is corrupted or stale:

```bash
rm -rf ~/.claude/plugins/cache/your-marketplace-name
```

Then restart Claude Code and reinstall:

```
/plugin install marketplace-url
```

#### Fix 3: Check scope conflicts

If you have `enabledPlugins: {}` (empty) at the project scope, it may override user-scope settings. Either:

- Remove the empty `enabledPlugins` key from `.claude/settings.json` (project scope)
- Or explicitly enable the plugins at the project scope too

#### Fix 4: Verify plugin.json manifest

Ensure each plugin directory has a valid `.claude-plugin/plugin.json` (or `plugin.json` at root). A malformed manifest will prevent the plugin from loading even if it's in the cache.

```bash
# Check manifest exists and is valid JSON
cat ~/.claude/plugins/cache/your-marketplace/your-plugin/.claude-plugin/plugin.json | python3 -m json.tool
```

### Common Pitfalls

| Issue | Cause | Fix |
|-------|-------|-----|
| Plugin count wrong | Stale cache data | Clear cache and restart |
| Plugin in cache but not installed | Not in `enabledPlugins` | Re-enable via `/plugin` |
| Plugin enabled but not loading | Bad manifest or missing files | Check plugin.json validity |
| Project overrides user plugins | Empty `enabledPlugins: {}` at project scope | Remove empty key or add plugins to project scope |
| Plugin works in one project but not another | Scope mismatch | Enable at user scope for global access |
