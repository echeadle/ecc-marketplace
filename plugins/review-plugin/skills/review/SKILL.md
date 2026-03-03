---
name: review
description: Review code for bugs, security, and performance
---

Review the code I've selected or the recent changes for:
- Potential bugs or edge cases
- Security concerns
- Performance issues
- Readability improvements

If no specific code is selected, check `git diff HEAD~1` for the last commit's changes and review those. If there are uncommitted changes, review `git diff` as well.

## Output format

For each finding, use this format:

**[severity] file:line — summary**
description and suggested fix

Severity levels:
- **CRITICAL** — Bugs, security vulnerabilities, or data loss risks that must be fixed
- **WARNING** — Logic issues, missing edge cases, or performance problems worth addressing
- **NITPICK** — Style, naming, or minor improvements that are optional

End with a summary table:

| Severity | Count |
|:---------|:-----:|
| Critical | N |
| Warning  | N |
| Nitpick  | N |

Be concise and actionable. Skip nitpicks if there are critical or warning issues to focus on.
