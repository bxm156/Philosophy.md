---
layout: default
title: Conventional Commits
parent: Methodologies
grand_parent: Philosophies
nav_order: 2
---

# Conventional Commits Philosophy

> "A lightweight convention on top of commit messages that creates structured, machine-readable commit history"

## Overview

Conventional Commits is a specification for writing standardized commit messages that are both human-readable and machine-parseable. By following a simple convention, teams can automate version management, changelog generation, and communicate changes clearly across projects.

**Origin**: Built on the Angular commit convention, formalized as an open specification

**Core Idea**: Structure commit messages in a predictable format that describes what changed, why it changed, and what impact it has

**Primary Benefits**:
- Automated semantic versioning
- Automated CHANGELOG generation
- Clear communication of intent
- Easier project navigation and archaeology
- Triggerable CI/CD processes

---

## The Specification

### Basic Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Components Explained

1. **Type** (required): The category of change
2. **Scope** (optional): What part of the codebase is affected
3. **Description** (required): Brief summary of the change
4. **Body** (optional): Detailed explanation of what and why
5. **Footer(s)** (optional): Breaking changes, issue references, metadata

---

## Core Principles

### 1. Commits MUST Be Prefixed with a Type

**Why**: Types categorize changes for humans and automation

**Standard Types**:
- `feat`: A new feature (maps to MINOR in SemVer)
- `fix`: A bug fix (maps to PATCH in SemVer)

**Recommended Additional Types** (Angular convention):
- `build`: Changes to build system or dependencies
- `chore`: Routine tasks, maintenance
- `ci`: Continuous integration changes
- `docs`: Documentation only
- `style`: Code style/formatting (no logic change)
- `refactor`: Code restructuring (no behavior change)
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `revert`: Reverting a previous commit

#### Examples

```bash
# Feature commits
feat: add user authentication
feat(api): implement OAuth2 login flow
feat(ui): add dark mode toggle

# Bug fix commits
fix: resolve memory leak in cache
fix(parser): handle edge case with empty strings
fix(database): prevent race condition in transaction handling

# Documentation commits
docs: update API documentation for v2.0
docs(readme): add installation instructions for Windows

# Build system commits
build: upgrade to webpack 5
build(deps): bump axios from 0.21.1 to 0.27.2

# CI/CD commits
ci: add automated security scanning
ci(github): configure dependabot for npm updates

# Code quality commits
style: format code with prettier
refactor: extract validation logic to separate module
perf: optimize database queries with indexing

# Test commits
test: add unit tests for authentication service
test(e2e): add checkout flow integration tests
```

---

### 2. Breaking Changes MUST Be Indicated

**Why**: Breaking changes require major version bumps and careful migration planning

**Two Ways to Indicate Breaking Changes**:

#### Method 1: Exclamation Mark Before Colon

```bash
feat!: remove deprecated API endpoints
fix(api)!: change response format to match OpenAPI spec
refactor!: rename User model to Account
```

#### Method 2: BREAKING CHANGE Footer

```bash
feat(api): add pagination to user list endpoint

BREAKING CHANGE: The user list endpoint now returns paginated results.
Update your client to use the new `page` and `limit` query parameters.
Migration guide: https://docs.example.com/migration/v3
```

#### Examples with Context

```bash
# Breaking: API change
feat(api)!: change authentication to use JWT tokens

Previous bearer token authentication is no longer supported.
All clients must update to use JWT tokens with the new /auth/login endpoint.

BREAKING CHANGE: Bearer tokens deprecated in favor of JWT.
See migration guide: docs/migrations/v2-to-v3.md

# Breaking: Configuration change
chore!: update configuration file format

BREAKING CHANGE: Configuration format changed from JSON to YAML.
Run `migrate-config` script to convert existing config.json files.

# Breaking: Dependency update
build(deps)!: upgrade React from v16 to v18

BREAKING CHANGE: React 18 introduces new concurrent rendering features
that may affect component lifecycle behavior. Review the upgrade guide
before deploying to production.

Refs: https://react.dev/blog/2022/03/29/react-v18
```

---

### 3. Scope Provides Additional Context

**Why**: Scopes help navigate large codebases and filter commits by component

**Format**: `<type>(<scope>): <description>`

```bash
# Frontend scopes
feat(ui): add loading spinner component
fix(forms): validate email format correctly
refactor(navigation): simplify routing logic

# Backend scopes
feat(api): add rate limiting middleware
fix(database): resolve connection pool exhaustion
perf(cache): implement Redis caching layer

# Service/module scopes
feat(auth): implement two-factor authentication
fix(payments): handle Stripe webhook retries
docs(api): document webhook event types

# Package/library scopes (monorepo)
feat(logger): add structured logging with context
fix(validation): handle nested object validation
test(utils): add tests for date formatting helpers

# Feature scopes
feat(checkout): add guest checkout option
fix(search): improve relevance ranking
perf(analytics): batch event submissions
```

#### Multiple Scopes (Alternative: Use Broader Scope)

```bash
# Instead of multiple scopes (not in spec)
feat(ui,api): add user profile editing

# Better: Choose the primary scope
feat(ui): add user profile editing interface

# Or use a broader scope that encompasses both
feat(profile): add user profile editing functionality
```

---

### 4. Description MUST Be Clear and Concise

**Why**: The description is what appears in logs and changelogs

**Rules**:
- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period at the end
- Keep under 72 characters

```bash
# ✅ GOOD: Imperative, concise, clear
feat: add email notifications
fix: resolve race condition in user creation
docs: update installation guide
refactor: extract duplicate validation logic

# ❌ BAD: Past tense
feat: added email notifications
fix: resolved race condition

# ❌ BAD: Present continuous
feat: adding email notifications
fix: resolving race condition

# ❌ BAD: Capitalized, with period
feat: Add email notifications.
fix: Resolve race condition.

# ❌ BAD: Too vague
feat: update code
fix: fix bug
chore: changes

# ❌ BAD: Too long
feat: add email notifications for user registration, password reset, account updates, and promotional campaigns with configurable templates
```

#### Good vs. Bad Descriptions

```bash
# Vague → Specific
❌ fix: update validation
✅ fix: prevent negative quantities in cart

❌ feat: improve performance
✅ perf: add database indexes to speed up user queries

❌ docs: update docs
✅ docs: add examples for authentication endpoints

# Implementation details → User impact
❌ refactor: change variable names
✅ refactor: simplify discount calculation logic

❌ fix: update regex
✅ fix: accept international phone number formats

# Too technical → Clear intent
❌ feat: add Redis integration
✅ feat: implement caching to improve response times
```

---

### 5. Body Provides Detailed Context

**Why**: Explain the reasoning and context that won't fit in the description

**Format**:
- One blank line after description
- Wrap at 72 characters
- Explain WHAT and WHY, not HOW (code shows how)

```bash
feat(auth): add OAuth2 support for Google and GitHub

This allows users to sign in using their existing Google or GitHub
accounts instead of creating new credentials. This reduces friction
in the signup process and improves security by delegating authentication
to established providers.

Implementation uses the `passport` library with the respective OAuth2
strategies. Configuration is loaded from environment variables to support
different client IDs per deployment environment.

Closes #234
```

#### When to Include a Body

**Include body when**:
- The change is non-obvious
- There are important trade-offs
- Context will help future maintainers
- The change affects multiple systems
- Migration steps are needed

```bash
# Simple fix - no body needed
fix: correct typo in error message

# Complex fix - body adds value
fix(database): prevent deadlock in order processing

The previous implementation acquired locks in different orders depending
on the code path, which could cause deadlocks under high concurrency.
This fix ensures locks are always acquired in a consistent order
(customer → order → items) regardless of the operation.

This may slightly reduce throughput in the edge case where multiple
operations on the same order happen simultaneously, but prevents the
system from deadlocking entirely.

Related: #567, #589
```

---

### 6. Footers Contain Metadata

**Why**: Machine-readable references and metadata

**Common Footers**:
- `BREAKING CHANGE:` - Describes breaking changes
- `Refs:` - Related tickets/URLs
- `Closes:` - Auto-closes issues
- `Co-authored-by:` - Multiple authors
- `Signed-off-by:` - DCO compliance
- `Reviewed-by:` - Code reviewers

```bash
feat(api): add webhook delivery retry mechanism

Webhooks now retry up to 3 times with exponential backoff if the
recipient endpoint returns a 5xx error or times out. This improves
reliability for integrations with occasionally unstable endpoints.

Refs: #123, #145
Co-authored-by: Jane Doe <jane@example.com>
Reviewed-by: John Smith <john@example.com>
```

#### Multiple Footers

```bash
fix(payments)!: update Stripe API to latest version

The older Stripe API version is being deprecated. This update migrates
to the latest version with improved error handling and webhook signatures.

BREAKING CHANGE: Stripe webhook signature validation is now mandatory.
Update your webhook endpoints to verify signatures using the new
`stripe.webhooks.constructEvent` method.

Migration guide: docs/migrations/stripe-v3.md

Refs: #789
Closes: #790, #791
Reviewed-by: Alice Johnson <alice@example.com>
Signed-off-by: Bob Williams <bob@example.com>
```

#### Issue References

```bash
# Close a single issue
fix: resolve login redirect loop

Closes #123

# Close multiple issues
fix: handle various edge cases in form validation

Closes #101, #102, #103

# Reference without closing
feat: add CSV export functionality

Related work on Excel export in #200
Refs: #150, #175

# Different platforms
fix: resolve Docker build on Apple Silicon

Fixes #45
See also: https://github.com/other-org/other-repo/issues/123
```

---

## Semantic Versioning Integration

### How Commits Map to Versions

```bash
# PATCH version bump (1.0.0 → 1.0.1)
fix: resolve security vulnerability
fix(api): handle null pointer exception
perf: optimize database queries

# MINOR version bump (1.0.0 → 1.1.0)
feat: add user profile editing
feat(api): implement search functionality

# MAJOR version bump (1.0.0 → 2.0.0)
feat!: redesign authentication system
fix(api)!: change response format

# Or with footer
feat: add new endpoints

BREAKING CHANGE: Old endpoints removed
```

### Automated Versioning

```json
// package.json with standard-version
{
  "scripts": {
    "release": "standard-version"
  }
}
```

```bash
# Automatically determines version based on commits
$ npm run release

# Analyzes commits since last tag:
# - 3 feat commits → MINOR bump
# - 7 fix commits → included in MINOR
# - 0 BREAKING CHANGE → no MAJOR bump
# Result: 1.4.3 → 1.5.0
```

---

## Automated CHANGELOG Generation

### From Commits to Changelog

**Commits**:
```bash
feat(auth): add two-factor authentication
feat(api): implement rate limiting
fix(database): resolve connection leak
fix(ui): correct button alignment on mobile
docs: update API documentation
perf(cache): implement Redis caching
```

**Generated CHANGELOG.md**:
```markdown
# Changelog

## [1.5.0] - 2025-11-17

### Features
- **auth**: add two-factor authentication
- **api**: implement rate limiting

### Bug Fixes
- **database**: resolve connection leak
- **ui**: correct button alignment on mobile

### Performance Improvements
- **cache**: implement Redis caching

### Documentation
- update API documentation
```

### Tools for CHANGELOG Generation

```bash
# standard-version (JavaScript)
npm install --save-dev standard-version
npm run release

# conventional-changelog
npm install -g conventional-changelog-cli
conventional-changelog -p angular -i CHANGELOG.md -s

# semantic-release (full automation)
npm install --save-dev semantic-release
# Automatically: version, changelog, git tag, npm publish, GitHub release
```

---

## Real-World Workflows

### 1. Feature Development

```bash
# Start feature branch
git checkout -b feature/user-avatars

# Make commits following convention
git commit -m "feat(profile): add avatar upload functionality"
git commit -m "test(profile): add avatar upload tests"
git commit -m "docs(api): document avatar endpoints"

# Squash or keep detailed history
git merge feature/user-avatars --no-ff
# Result: Clean, categorized history
```

### 2. Bug Fix with Context

```bash
# Investigate bug #456
git commit -m "fix(checkout): prevent duplicate order submissions

When users double-clicked the submit button, multiple orders were
created. This fix disables the button immediately on first click
and shows a loading state until the request completes.

The fix also adds idempotency tokens to the API layer as a
safeguard against network-level retries causing duplicates.

Closes #456"
```

### 3. Breaking Change with Migration

```bash
git commit -m "refactor(api)!: standardize error response format

BREAKING CHANGE: All API errors now return consistent JSON structure.

Before:
{
  \"error\": \"Something went wrong\"
}

After:
{
  \"error\": {
    \"code\": \"VALIDATION_ERROR\",
    \"message\": \"Something went wrong\",
    \"details\": { ... }
  }
}

Migration: Update client error handling to access error.error.message
instead of error.error.

Refs: #678
Closes: #123, #234"
```

### 4. Monorepo with Multiple Packages

```bash
# Scope indicates which package changed
feat(logger): add structured logging with context
fix(validation): handle null values in nested objects
test(utils): add comprehensive date formatting tests
build(deps): update shared testing dependencies

# CI/CD can trigger builds only for affected packages
# - logger changed → rebuild @company/logger
# - validation changed → rebuild @company/validation
# - Both depend on utils → rebuild both if utils changes
```

---

## Tooling Integration

### 1. Commit Message Linting

**commitlint** - Enforce conventional commits

```bash
# Install
npm install --save-dev @commitlint/cli @commitlint/config-conventional

# Configure (commitlint.config.js)
module.exports = {
  extends: ['@commitlint/config-conventional']
};

# Add to git hooks (with husky)
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'
```

**Rejects invalid commits**:
```bash
$ git commit -m "updated some stuff"
❌ subject may not be empty [subject-empty]
❌ type may not be empty [type-empty]

$ git commit -m "feat add new feature"
❌ subject may not be empty [subject-empty]
❌ type must have a space before description [type-space]

$ git commit -m "feat: add new feature"
✓ commit message passes all checks
```

### 2. Interactive Commit CLI

**commitizen** - Guide users to write conventional commits

```bash
# Install
npm install --save-dev commitizen cz-conventional-changelog

# Use instead of git commit
$ git cz

? Select the type of change: (Use arrow keys)
❯ feat:     A new feature
  fix:      A bug fix
  docs:     Documentation only changes
  style:    Changes that don't affect code meaning
  refactor: Code change that neither fixes a bug nor adds a feature
  perf:     A code change that improves performance
  test:     Adding missing tests

? What is the scope of this change? (press enter to skip) auth

? Write a short description: add OAuth2 support for Google

? Provide a longer description: (press enter to skip)
Allows users to sign in using their Google account.
Uses passport.js with the google-oauth20 strategy.

? Are there any breaking changes? No

? Does this change affect any open issues? Yes

? Add issue references: Closes #123

# Generates perfect commit:
# feat(auth): add OAuth2 support for Google
#
# Allows users to sign in using their Google account.
# Uses passport.js with the google-oauth20 strategy.
#
# Closes #123
```

### 3. CI/CD Integration

```yaml
# .github/workflows/version-and-release.yml
name: Version and Release

on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0  # Fetch all history for changelog

      - name: Setup Node.js
        uses: actions/setup-node@v3

      - name: Install dependencies
        run: npm ci

      - name: Run semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: npx semantic-release

# Automatically:
# 1. Analyzes commits since last release
# 2. Determines new version number
# 3. Generates CHANGELOG.md
# 4. Creates git tag
# 5. Publishes to npm
# 6. Creates GitHub release
```

### 4. Pre-commit Hooks

```bash
# .husky/prepare-commit-msg
#!/bin/sh

# Add issue number from branch name to commit message
BRANCH_NAME=$(git symbolic-ref --short HEAD)
ISSUE_NUMBER=$(echo "$BRANCH_NAME" | grep -oP '(?<=issue-)\d+')

if [ -n "$ISSUE_NUMBER" ]; then
  echo "\nRefs: #$ISSUE_NUMBER" >> "$1"
fi
```

---

## Advanced Patterns

### 1. Revert Commits

```bash
# Revert a previous commit
git revert abc123

# Conventional commit for revert
revert: revert "feat(api): add new endpoint"

This reverts commit abc123def456.

The new endpoint introduced performance issues under high load.
Reverting until we can optimize the database queries.

Refs: #890
```

### 2. Merge Commits

```bash
# Squash merge with conventional commit
git merge --squash feature/new-feature
git commit -m "feat: add user notification system

Merges feature/new-feature branch which includes:
- Email notification templates
- Push notification integration
- Notification preference UI
- Background job for sending notifications

Closes #456"
```

### 3. Multiple Types in One Commit (Avoid!)

```bash
# ❌ BAD: Don't mix types
git commit -m "feat: add new feature and fix bug and update docs"

# ✅ GOOD: Separate commits
git commit -m "feat: add notification system"
git commit -m "fix: resolve notification delivery delay"
git commit -m "docs: document notification API"
```

### 4. Versioned Documentation

```bash
# Documentation changes can trigger patch releases
docs: update installation guide for v3.0

Added troubleshooting section for common installation issues.
Updated Windows installation steps for new build process.

# Might trigger 3.0.0 → 3.0.1 if using semantic-release with
# configuration that includes docs in release types
```

---

## Configuration Examples

### commitlint.config.js (Custom Rules)

```javascript
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Custom types for your organization
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature
        'fix',      // Bug fix
        'docs',     // Documentation
        'style',    // Formatting
        'refactor', // Code restructuring
        'perf',     // Performance
        'test',     // Tests
        'build',    // Build system
        'ci',       // CI/CD
        'chore',    // Maintenance
        'revert',   // Revert previous commit
        'security'  // Security fixes (custom)
      ]
    ],
    // Require scope for certain types
    'scope-empty': [2, 'never'],
    // Limit subject length
    'subject-max-length': [2, 'always', 72],
    // Enforce lowercase subject
    'subject-case': [2, 'always', 'lower-case'],
    // No period at end of subject
    'subject-full-stop': [2, 'never', '.'],
    // Body must be separated by blank line
    'body-leading-blank': [2, 'always'],
    // Footer must be separated by blank line
    'footer-leading-blank': [2, 'always']
  }
};
```

### .versionrc (standard-version Configuration)

```json
{
  "types": [
    {"type": "feat", "section": "Features"},
    {"type": "fix", "section": "Bug Fixes"},
    {"type": "perf", "section": "Performance Improvements"},
    {"type": "revert", "section": "Reverts"},
    {"type": "docs", "section": "Documentation", "hidden": false},
    {"type": "style", "section": "Styles", "hidden": true},
    {"type": "chore", "section": "Miscellaneous", "hidden": true},
    {"type": "refactor", "section": "Code Refactoring", "hidden": false},
    {"type": "test", "section": "Tests", "hidden": true},
    {"type": "build", "section": "Build System", "hidden": true},
    {"type": "ci", "section": "CI/CD", "hidden": true}
  ],
  "releaseCommitMessageFormat": "chore(release): {{currentTag}}",
  "skip": {
    "changelog": false
  }
}
```

### release.config.js (semantic-release)

```javascript
module.exports = {
  branches: ['main', 'next'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    '@semantic-release/npm',
    '@semantic-release/github',
    [
      '@semantic-release/git',
      {
        assets: ['package.json', 'CHANGELOG.md'],
        message: 'chore(release): ${nextRelease.version}\n\n${nextRelease.notes}'
      }
    ]
  ]
};
```

---

## Team Adoption Strategies

### 1. Gradual Introduction

**Week 1**: Education
- Share specification with team
- Explain benefits (automation, clarity)
- Show examples from other projects

**Week 2**: Opt-in
- Add commitizen for those who want help
- Don't enforce yet
- Celebrate good examples

**Week 3**: Soft enforcement
- Add commitlint as warning (not error)
- Review together during standups
- Help each other improve

**Week 4**: Full adoption
- Enforce with commit hooks
- Integrate with CI/CD
- Start generating changelogs

### 2. Templates and Cheat Sheets

**Git commit template (.gitmessage)**:
```
# <type>[optional scope]: <description>
# |<---- Max 72 characters ---->|

# [optional body]
# |<---- Wrap at 72 characters ---->|

# [optional footer(s)]

# Types:
#   feat:     New feature
#   fix:      Bug fix
#   docs:     Documentation
#   style:    Formatting
#   refactor: Code restructuring
#   perf:     Performance
#   test:     Tests
#   build:    Build system
#   ci:       CI/CD
#   chore:    Maintenance
#
# Breaking changes:
#   Add ! after type: feat!: breaking change
#   Or add footer: BREAKING CHANGE: description
#
# Close issues:
#   Closes #123
#   Fixes #456, #789
```

Enable with:
```bash
git config commit.template .gitmessage
```

### 3. IDE Integration

**VSCode Extension**: Conventional Commits
```json
// .vscode/settings.json
{
  "conventionalCommits.scopes": [
    "api",
    "ui",
    "database",
    "auth",
    "payments"
  ],
  "conventionalCommits.showEditor": true
}
```

**JetBrains IDEs**: Git Commit Template Plugin

---

## Common Questions

### Q: Do I need to follow this for every commit?

**A**: It depends on your workflow:

**Squash and merge**: Commits in feature branches can be informal. Only the merge commit to main needs to be conventional.

```bash
# Feature branch (informal is OK)
git commit -m "wip: trying new approach"
git commit -m "working on validation"
git commit -m "tests passing"

# Squash merge to main (must be conventional)
git merge --squash feature/validation
git commit -m "feat(api): add request validation middleware"
```

**Preserve history**: Every commit should be conventional since all commits appear in main branch history.

```bash
# Every commit matters
git commit -m "feat(api): add validation middleware"
git commit -m "test(api): add validation tests"
git commit -m "docs(api): document validation rules"
git merge feature/validation --no-ff
```

### Q: What about commits that don't fit a type?

**A**: Use `chore` for miscellaneous work:

```bash
chore: update .gitignore
chore: bump dependencies
chore: fix typo in code comment
chore: reorganize file structure
```

Or consider if the commit should be part of a larger commit:

```bash
# Instead of separate commits:
chore: add new file
chore: import dependencies
chore: write function

# One meaningful commit:
feat(utils): add date formatting helper functions
```

### Q: Should I include issue numbers in every commit?

**A**: Only when relevant:

```bash
# Yes: Commit directly addresses an issue
fix: resolve login redirect loop

Closes #123

# No: Part of general feature work
feat(api): add endpoint parameter validation

# Optional: Related but not closing
refactor: simplify authentication logic

Related to #456
```

### Q: How do I handle commits that affect multiple scopes?

**A**: Choose the most appropriate option:

1. **Use the primary scope**:
```bash
feat(api): add user profile editing
# Even though UI also changes, API is the primary change
```

2. **Use a broader scope**:
```bash
feat(profile): add user profile editing
# Encompasses both API and UI
```

3. **Split into multiple commits**:
```bash
feat(api): add user profile update endpoint
feat(ui): add profile editing interface
```

### Q: What about merge commits?

**A**: Depends on workflow:

**Squash merge**: No merge commits, the squashed commit follows convention

**Merge commits**: Can use conventional format or simple merge message:
```bash
# Conventional
feat: merge user authentication feature

# Simple (generated by GitHub)
Merge pull request #123 from user/feature-branch
```

Configure in `.versionrc`:
```json
{
  "skip": {
    "commit": true  // Skip merge commits in changelog
  }
}
```

---

## Anti-Patterns

### ❌ Vague Descriptions

```bash
# Bad
fix: fix bug
feat: update code
chore: changes

# Good
fix: prevent null pointer exception in user service
feat: add email notifications for order confirmations
chore: update Node.js to v18 LTS
```

### ❌ Too Much Detail in Description

```bash
# Bad - save for body
feat: add user authentication with JWT tokens using the jsonwebtoken library with RSA256 signing algorithm and refresh token rotation

# Good - details in body
feat(auth): add JWT-based authentication

Implements authentication using JWT tokens with the jsonwebtoken library.
Uses RSA256 signing algorithm for enhanced security. Includes automatic
refresh token rotation to prevent token theft.

Closes #234
```

### ❌ Mixing Multiple Changes

```bash
# Bad
feat: add notifications, fix login bug, update docs

# Good
feat(notifications): add email notification system
fix(auth): resolve login redirect issue
docs: update authentication guide
```

### ❌ Implementation Details Instead of Impact

```bash
# Bad - too technical
feat: add Redis cache with connection pooling using ioredis

# Good - user impact
perf: improve API response times with caching

# Details in body if needed
feat: improve API response times with caching

Implements Redis caching layer with connection pooling using ioredis.
Cache TTL is configurable per endpoint. Reduces average response time
from 300ms to 50ms for frequently accessed data.
```

### ❌ Inconsistent Capitalization

```bash
# Bad
Feat: Add feature
feat: Add Feature
FEAT: add feature

# Good
feat: add feature
```

### ❌ Ending Description with Period

```bash
# Bad
feat: add new feature.

# Good
feat: add new feature
```

---

## Benefits Summary

### For Developers

- **Clear history**: Easy to understand what changed and why
- **Better code review**: Reviewers understand intent immediately
- **Faster navigation**: Find when feature was added or bug was fixed
- **Simplified debugging**: `git bisect` becomes more meaningful

### For Teams

- **Communication**: Standardized format reduces ambiguity
- **Onboarding**: New team members understand conventions quickly
- **Collaboration**: Easier to collaborate on complex features
- **Process**: Consistent workflow across all contributors

### For Projects

- **Automation**: Automatic versioning and changelog generation
- **Release management**: Clear view of what's in each release
- **Dependency updates**: Automated tools can create conventional commits
- **Open source**: Contributors can follow standard conventions

### For Users

- **Transparency**: Clear changelogs explain what changed
- **Predictability**: SemVer helps understand impact of updates
- **Documentation**: Automatically generated release notes
- **Trust**: Professional commit history indicates quality project

---

## Tools and Resources

### Commit Message Tools

- **commitizen**: Interactive commit CLI
- **commitlint**: Lint commit messages
- **husky**: Git hooks made easy
- **validate-commit-msg**: Alternative to commitlint

### Versioning Tools

- **standard-version**: Automated versioning and changelog
- **semantic-release**: Full release automation
- **lerna**: Monorepo versioning with conventional commits
- **release-please**: Google's release automation

### Editor Plugins

- **VSCode**: Conventional Commits extension
- **JetBrains**: Git Commit Template plugin
- **Vim**: committia.vim
- **Emacs**: conventional-changelog.el

### CI/CD Integration

- **GitHub Actions**: semantic-release-action
- **GitLab CI**: semantic-release support
- **CircleCI**: orbs for semantic versioning
- **Jenkins**: semantic-release plugin

---

## Migration Strategy

### For Existing Projects

**Step 1: Audit current practices**
```bash
# Analyze existing commits
git log --oneline --all | head -50

# Identify patterns
git log --format=%s | sort | uniq -c | sort -rn
```

**Step 2: Add tooling (non-breaking)**
```bash
# Install commitizen and commitlint
npm install --save-dev commitizen cz-conventional-changelog
npm install --save-dev @commitlint/cli @commitlint/config-conventional

# Make available but don't enforce yet
npx commitizen init cz-conventional-changelog --save-dev --save-exact
```

**Step 3: Team education**
- Share this document
- Hold workshop or team meeting
- Create cheat sheet for quick reference
- Add examples to contribution guide

**Step 4: Soft enforcement**
```bash
# Add commitlint as warning only
# .husky/commit-msg
#!/bin/sh
npx --no -- commitlint --edit "$1" || echo "Warning: Commit message doesn't follow conventional commits"
# Don't exit with error yet
exit 0
```

**Step 5: Full adoption**
```bash
# Enable enforcement
# .husky/commit-msg
#!/bin/sh
npx --no -- commitlint --edit "$1"
# Now exits with error on invalid commits
```

**Step 6: Automation**
```bash
# Add standard-version or semantic-release
npm install --save-dev standard-version

# Update package.json
{
  "scripts": {
    "release": "standard-version"
  }
}

# First release
npm run release -- --first-release
```

### Handling Legacy History

**Option 1: Start fresh**
- Begin using conventional commits from a specific version (e.g., v2.0.0)
- Document in CHANGELOG that previous versions don't follow convention
- Use automation going forward

**Option 2: Rewrite history (dangerous!)**
- Only for projects where you control all clones
- Use interactive rebase to fix commit messages
- Force push (coordinate with team)

```bash
# Not recommended unless absolutely necessary
git rebase -i HEAD~50
# Edit each commit message to follow convention
git push --force
```

**Option 3: Create mapping file**
- Create a `.commit-mapping.json` that maps old commits to conventional format
- Use with changelog tools that support custom mappings
- Preserves original history

---

## Examples from Real Projects

### Angular

```bash
feat($compile): simplify isolate scope bindings

Changed the isolate scope binding options to:
  - @attr - attribute binding (including interpolation)
  - =model - by-directional model binding
  - &expr - expression execution binding

This change simplifies the terminology as well as the syntax.

BREAKING CHANGE: isolate scope bindings definition has changed and
the inject option for the directive controller injection was removed.

To migrate the code follow the example below:

Before:
scope: {
  myAttr: 'attribute',
  myBind: 'bind',
  myExpression: 'expression',
  myEval: 'evaluate',
  myAccessor: 'accessor'
}

After:
scope: {
  myAttr: '@',
  myBind: '@',
  myExpression: '&',
  myEval: '&',
  myAccessor: '='
}

Closes #2123
```

### Electron

```bash
fix(windows): fix crash when closing window from taskbar

When closing a window from the taskbar (right-click → close),
Electron would crash on Windows 10. This was caused by the window
destruction code being called twice.

The fix ensures window destruction is idempotent by checking if
the window has already been destroyed before attempting cleanup.

Fixes #12345
```

### React

```bash
feat(hooks): add useTransition hook

Adds a new built-in Hook for managing transitions:
const [isPending, startTransition] = useTransition();

This allows you to mark certain updates as "transitions" which
React can interrupt and prioritize behind more urgent updates.

This is useful for keeping the UI responsive during slow state
updates like filtering large lists.

Documentation: https://react.dev/hooks/use-transition
```

---

## Summary

Conventional Commits provides a simple, powerful convention for structuring commit messages that:

1. **Standardizes communication** across teams and projects
2. **Enables automation** of versioning and changelogs
3. **Improves code archaeology** by making history searchable and meaningful
4. **Reduces cognitive load** by providing clear templates
5. **Integrates seamlessly** with modern development workflows

**The core format**:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Key principles**:
- Use imperative mood
- Keep descriptions concise and clear
- Mark breaking changes explicitly
- Provide context in body when helpful
- Reference issues in footers

**Start small**: Even adopting just `feat:` and `fix:` provides value. You can expand to the full specification as your team becomes comfortable with the convention.

---

## Further Reading

### Official Resources
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Angular Commit Convention](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
- [Semantic Versioning](https://semver.org/)

### Tools Documentation
- [commitlint](https://commitlint.js.org/)
- [commitizen](https://github.com/commitizen/cz-cli)
- [standard-version](https://github.com/conventional-changelog/standard-version)
- [semantic-release](https://semantic-release.gitbook.io/)

### Related Philosophies
- [Git Workflow Best Practices](../../methodologies/GIT.PHILOSOPHY.md) *(if exists)*
- [Continuous Integration](../../methodologies/CI_CD.PHILOSOPHY.md) *(if exists)*
- [Documentation Philosophy](../../methodologies/DOCUMENTATION.PHILOSOPHY.md) *(if exists)*

---

**Version**: 1.0.0 (following our own convention!)
**Last Updated**: 2025-11-17
**Specification Version**: v1.0.0
**License**: CC BY 3.0 (same as Conventional Commits spec)
