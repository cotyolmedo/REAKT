# REAKT Development Workflow

## Main tools

Current toolchain:

- Git
- GitHub
- VS Code
- Arduino IDE
- Flutter
- Codex
- PowerShell/terminal

## Repository workflow

Before changing code:

1. inspect the relevant files
2. identify the affected subsystem
3. check relevant documentation
4. make the smallest coherent change
5. validate
6. update documentation if necessary
7. review the diff

## Git

Use focused commits.

Example categories:

```text
feat:
fix:
refactor:
docs:
test:
chore:
```

Do not commit secrets.

Do not force-push.

Do not rewrite shared history.

## Branching

A simple workflow is preferred while the project is small.

Use feature branches when a change is large enough to isolate safely.

## Codex

Codex should operate within the repository rules in `AGENTS.md`.

For complex tasks, use `.agent/PLANS.md`.

Codex must not automatically commit/push unless explicitly instructed.

## Local secrets

Keep local-only configuration outside tracked files.

Examples:

- Wi-Fi credentials
- Supabase secrets
- API keys
- tokens

## Code review

Before accepting a substantial Codex change, inspect:

- changed files
- behavior
- architecture impact
- error handling
- resource usage
- hardware compatibility
- tests
- documentation

Do not accept generated code merely because it compiles.
