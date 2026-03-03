---
name: review-changes
description: Review all changes since the last commit for bugs, security, and quality
---

Review all changes since the last commit. Check both staged and unstaged changes using `git diff` and `git diff --cached`.

For each finding, report:

**[severity] file:line — summary**
description and suggested fix

Severity levels:
- **CRITICAL** — Bugs, security vulnerabilities, or data loss risks
- **WARNING** — Logic issues, missing edge cases, or performance problems
- **NITPICK** — Style or minor improvements

End with a summary table of findings by severity.

Be concise and actionable.
