---
name: gh-workflow-create
description: >
  Skill for creating and adding GitHub Actions workflow files (.github/workflows/*.yaml).
  Use this skill whenever the user asks to add a CI/CD pipeline, set up GitHub Actions,
  create a deployment workflow, add linting to PRs, automate releases, or anything
  related to creating or modifying GitHub Actions workflows. Trigger even if the user
  doesn't explicitly say "GitHub Actions" — phrases like "run tests on push",
  "automate deploy", "add CI", or "PR checks" all qualify.
---

# GitHub Actions Workflow Creation Guide

This skill provides guidelines for creating secure, maintainable GitHub Actions workflows.

## Language Rules

- Write all communication with the user in Japanese.
- Write all inline comments within workflow YAML files in Japanese.
- The skill instructions themselves are in English.

## File Naming

- Always use `.yaml` extension, never `.yml`.

## Core Principles

- **Avoid 3rd party actions whenever possible.** If you can achieve the same result with `run:` shell commands, do that instead.
- **When 3rd party actions are necessary, pin to full commit SHA with a version comment.** This enables Renovate to automatically update them.
- **Always validate with actionlint and ghalint after creating a workflow.**

## Using 3rd Party Actions

When a 3rd party action is unavoidable (e.g., `actions/checkout`), use this exact format:

```yaml
- uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 # v4.1.7
```

Rules:
- Use the full 40-character commit SHA, never a tag like `v4`
- Add an inline comment with the version tag (e.g., `# v4.1.7`) so Renovate can update both the SHA and comment together
- If the SHA is unknown, look it up before writing the workflow

**How to look up a commit SHA for a tag:**
```bash
gh api repos/{owner}/{repo}/git/ref/tags/{tag} --jq '.object.sha'
```
Note: For annotated tags, `.object.type` will be `tag` instead of `commit`. In that case, follow `.object.url` to get the actual commit SHA.

## Security

### Declare minimal permissions explicitly

Set restrictive defaults at the workflow level. Add permissions per job only as needed.

```yaml
permissions:
  contents: read

jobs:
  deploy:
    permissions:
      contents: read
      deployments: write
```

- Never use `read-all` or `write-all`
- Never omit `permissions` (ghalint `job_permissions` rule)

### Pass secrets at the step level only

Do not set secrets in workflow-level or job-level `env:`. Reference them only in the `env:` of the specific step that needs them.

```yaml
# Good
steps:
  - run: deploy.sh
    env:
      API_KEY: ${{ secrets.API_KEY }}

# Bad — ghalint will flag this
env:
  API_KEY: ${{ secrets.API_KEY }}
```

### Prevent script injection

Never embed `${{ }}` expressions directly in `run:`. Pass them through environment variables.

```yaml
# Dangerous
- run: echo "${{ github.event.pull_request.title }}"

# Safe
- run: echo "$PR_TITLE"
  env:
    PR_TITLE: ${{ github.event.pull_request.title }}
```

Watch out for these untrusted inputs: `github.event.pull_request.title`, `.body`, `github.event.issue.title`, `.body`, `github.event.comment.body`, `github.head_ref`

### Set persist-credentials to false on checkout

```yaml
- uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 # v4.1.7
  with:
    persist-credentials: false
```

Prevents the token from lingering in the local git config. Enforced by ghalint `checkout_persist_credentials_should_be_false`.

### Do not use secrets: inherit

When calling reusable workflows, pass only the specific secrets needed instead of using `secrets: inherit`.

## Workflow Structure Best Practices

### Always set timeout-minutes

GitHub defaults to 6 hours. Prevent hung jobs from hogging runners.

```yaml
jobs:
  build:
    runs-on: ubuntu-24.04
    timeout-minutes: 30
```

Enforced by ghalint `job_timeout_minutes_is_required`.

### Control concurrency

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true  # PRビルドでは true、デプロイでは false
```

### Pin runner versions

Use `ubuntu-24.04` instead of `ubuntu-latest` for reproducibility.

### Use path filters to skip unnecessary runs

```yaml
on:
  push:
    paths:
      - 'src/**'
      - '.github/workflows/ci.yaml'
```

### Never use latest tag for container images

```yaml
jobs:
  test:
    container:
      image: node:20-slim
```

Enforced by ghalint `deny_job_container_latest_image`.

### Specify shell explicitly

```yaml
- run: echo "hello"
  shell: bash
```

Especially important in composite actions where ghalint enforces `action_shell_is_required`.

## Authentication Priority

1. **GITHUB_TOKEN** — repository-scoped, expires when the job ends. Always prefer this.
2. **OIDC tokens** — for cloud provider auth, use OIDC instead of storing credentials as secrets.
3. **GitHub App tokens** — for cross-repo access. Limit repositories and permissions.
4. **PAT** — last resort. Broad scope, high leak risk.

## Post-Creation Validation

After creating a workflow, always run both linters:

```bash
# actionlint: 構文・型・セキュリティチェック
actionlint .github/workflows/<new-workflow>.yaml

# ghalint: セキュリティポリシーチェック
ghalint run
```

Fix any errors and re-validate until both pass.

## Template: Basic CI Workflow

```yaml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

permissions:
  contents: read

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  test:
    runs-on: ubuntu-24.04
    timeout-minutes: 30
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 # v4.1.7
        with:
          persist-credentials: false
      - run: echo "ここにテストコマンドを書く"
        shell: bash
```
