# Git DevOps Workflow: Development to Production

## Overview

This document outlines the standard Git workflow for committing changes to the
`development` branch, creating pull requests to `main`, and keeping your local
repository in sync. This follows industry best practices for collaborative
development.

---

## Prerequisites

- Git installed and configured
- Repository cloned locally
- Remote origin configured
- Appropriate branch permissions

---

## Workflow Steps

### 1. Ensure You're on the Development Branch

```bash
# Check current branch
git branch

# If not on development, switch to it
git checkout development
# OR (newer Git versions)
git switch development

# Pull latest changes from remote development branch
git pull origin development
```

**Best Practice:** Always start with a fresh, up-to-date development branch to
avoid merge conflicts later.

---

### 2. Make Changes and Commit to Development

```bash
# Check what files have changed
git status

# Stage specific files
git add <filename>
# OR stage all changes
git add .

# Create a commit with a descriptive message
git commit -m "feat: add new Docker exercise for volume mounting"

# Follow conventional commit messages (see Best Practices section)
```

**Commit Message Format:**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`,
`build`

---

### 3. Push Changes to Remote Development Branch

```bash
# Push commits to remote development branch
git push origin development

# If it's the first push of this branch (not applicable here, but good to know)
git push -u origin development
```

**Best Practice:** Always push your commits after making them to ensure your
work is backed up remotely.

---

### 4. Create a Pull Request (PR) from Development to Main

### Option A: Using GitHub CLI (Recommended)

```bash
# Create PR from development to main
gh pr create \
  --base main \
  --head development \
  --title "feat: <brief description of changes>" \
  --body "$(cat <<'EOF'
## Summary
- <bullet point 1>
- <bullet point 2>
- <bullet point 3>

## Type of Change
- [ ] Bug fix
- [x] New feature
- [ ] Documentation update
- [ ] Refactoring

## Testing
- [ ] Tested locally with `docker-compose up`
- [ ] Verified Kubernetes manifests with `kubectl apply --dry-run=client`
- [ ] All existing tests pass

## Checklist
- [ ] Code follows project conventions
- [ ] Self-review completed
- [ ] Documentation updated (if needed)
EOF
)"
```

### Option B: Using GitHub Web Interface

1. After pushing to development, visit your repository on GitHub
2. You'll see a "Compare & pull request" button - click it
3. Ensure base is `main` and compare is `development`
4. Fill in the PR title and description
5. Click "Create pull request"

**Best Practice:** Always include a clear description, testing evidence, and
link any related issues.

---

### 5. Review, Approve, and Merge the PR

Once the PR is created:

1. **Team Review:** Request reviews from team members (if applicable)
2. **CI/CD Checks:** Wait for automated tests and checks to pass
3. **Address Feedback:** Make any requested changes
4. **Merge:** Once approved, merge the PR using one of these methods:

```bash
# Using GitHub CLI to merge (if you have permission)
gh pr merge <PR_NUMBER> --merge
# OR --squash (recommended for clean history)
gh pr merge <PR_NUMBER> --squash
# OR --rebase
gh pr merge <PR_NUMBER> --rebase
```

**Merge Strategy Options:**

- **Merge Commit:** Preserves all commit history (good for feature branches)
- **Squash & Merge:** Combines all commits into one (cleaner main history)
- **Rebase & Merge:** Replays commits on top of main (linear history)

---

### 6. Sync Main Branch Locally

After the PR is merged, update your local main branch:

```bash
# Switch to main branch
git checkout main
# OR
git switch main

# Pull the latest changes from remote main
git pull origin main

# (Optional) Update your development branch with main's changes
git checkout development
git merge main
git push origin development
```

**Best Practice:** Always pull main after a merge to ensure your local copy is
up-to-date.

---

## Complete Workflow Example

```bash
# 1. Start on development, ensure it's up-to-date
git switch development
git pull origin development

# 2. Make your changes (edit files, add features, fix bugs)
# ... do your work ...

# 3. Stage and commit changes
git add .
git commit -m "feat: add health check endpoint to Express app"

# 4. Push to development
git push origin development

# 5. Create PR using GitHub CLI
gh pr create --base main --head development \
  --title "feat: add health check endpoint" \
  --body "Adds /health endpoint for container orchestration readiness probes"

# 6. After PR is reviewed and merged on GitHub...
# 7. Switch to main and pull changes
git switch main
git pull origin main

# 8. (Optional) Update development with main's changes
git switch development
git merge main
git push origin development
```

---

## Best Practices Summary

### Branch Management

- ✅ Keep `main` always deployable and stable
- ✅ Use `development` for integrating features
- ✅ Create feature branches off development for large features:
  `git checkout -b feature/my-feature development`
- ❌ Never commit directly to `main`
- ❌ Avoid long-running development branches without merging

### Commit Hygiene

- ✅ Write clear, descriptive commit messages
- ✅ Use conventional commit format (`feat:`, `fix:`, `docs:`, etc.)
- ✅ Keep commits atomic (one logical change per commit)
- ❌ Don't commit secrets, credentials, or large binaries
- ❌ Don't use vague messages like "fix stuff" or "update"

### Pull Requests

- ✅ Create focused PRs (one feature/fix per PR)
- ✅ Include testing evidence in PR description
- ✅ Request reviews from appropriate team members
- ✅ Link related issues with "Closes #123" or "Fixes #123"
- ❌ Don't merge without passing CI/CD checks
- ❌ Don't ignore code review feedback

### Security

- ✅ Use `.gitignore` to prevent committing sensitive files
- ✅ Rotate credentials if accidentally committed (use `git-filter-repo`)
- ✅ Enable branch protection rules on `main` (require PR reviews, status
  checks)
- ✅ Use GitHub Secrets for CI/CD credentials

### Synchronization

- ✅ Pull before starting new work
- ✅ Pull after merges to main
- ✅ Regularly update feature branches with main/development
- ❌ Don't work on stale branches

---

## Common Git Commands Reference

| Command                    | Description                        |
| -------------------------- | ---------------------------------- |
| `git status`               | Check working tree status          |
| `git branch`               | List, create, or delete branches   |
| `git checkout <branch>`    | Switch branches (older syntax)     |
| `git switch <branch>`      | Switch branches (newer syntax)     |
| `git add <file>`           | Stage changes for commit           |
| `git commit -m "message"`  | Create a commit                    |
| `git push origin <branch>` | Push to remote branch              |
| `git pull origin <branch>` | Fetch and merge from remote        |
| `git merge <branch>`       | Merge another branch into current  |
| `gh pr create`             | Create pull request via GitHub CLI |
| `gh pr list`               | List pull requests                 |
| `gh pr status`             | Show status of current PR          |

---

## Troubleshooting

### Merge Conflicts

```bash
# If you encounter merge conflicts when pulling/merging
git status  # Identify conflicted files
# Edit files to resolve conflicts (look for <<<<, ====, >>>>)
git add <resolved-files>
git commit  # Complete the merge
```

### Undoing Commits (Before Push)

```bash
# Undo last commit, keep changes staged
git reset --soft HEAD~1

# Undo last commit, unstage changes
git reset HEAD~1

# Undo last commit, discard changes (CAREFUL!)
git reset --hard HEAD~1
```

### Fixing a PR After Push

```bash
# Make additional changes
git add .
git commit -m "fix: address review feedback"
git push origin development  # Updates the existing PR
```

---

## GitHub Branch Protection (Recommended)

To enforce these best practices, configure branch protection rules on GitHub:

1. Go to **Settings > Branches > Branch protection rules**
2. Add rule for `main` branch:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass (CI/CD)
   - ✅ Require branches to be up to date
   - ✅ Include administrators (optional)
   - ✅ Restrict pushes to matching branches

This ensures no one can push directly to `main` and all changes go through PR
review.

---

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)
- [Git Best Practices](https://git-scm.com/book/en/v2)
- [GitHub CLI Documentation](https://cli.github.com/manual/)

---

**Last Updated:** May 2026  
**Maintained by:** DevOps Team
