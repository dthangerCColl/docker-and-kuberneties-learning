# Git & GitHub Commands Reference

## Git & GitHub Workflow Overview

Git is a distributed version control system for tracking changes in source code. GitHub is a cloud platform for hosting Git repositories and collaborating on code. The typical workflow includes:

1. **Initialize**: Create or clone a repository
2. **Stage**: Add files to the staging area
3. **Commit**: Save changes to the local repository
4. **Branch**: Create and switch between branches
5. **Merge/Rebase**: Integrate changes from other branches
6. **Push/Pull**: Sync with remote repositories
7. **Collaborate**: Use GitHub for PRs, issues, and reviews
8. **Troubleshoot**: Recover from mistakes and resolve conflicts

---

## 20 Most Used Git & GitHub Commands

### 1. `git init`, `git clone`

**Start a new repo or copy an existing one**

```zsh
git init                        # Initialize a new repo in current directory
git clone <url>                 # Clone a remote repo
git clone <url> <dir>           # Clone into a specific directory
```

### 2. `git status`, `git log`, `git diff`

**Check repo state and changes**

```zsh
git status                      # Show changed files and staging status
git log                         # Show commit history
git log --oneline --graph       # Compact, visual history
git diff                        # Show unstaged changes
git diff --staged               # Show staged changes
```

### 3. `git add`, `git commit`, `git rm`, `git mv`

**Stage, commit, and manage files**

```zsh
git add <file>                  # Stage a file
git add .                       # Stage all changes
git commit -m "Message"         # Commit staged changes
git commit -am "Message"        # Add & commit tracked files
git rm <file>                   # Remove file from repo
git mv <old> <new>              # Rename or move a file
```

### 4. `git branch`, `git checkout`, `git switch`

**Branching and switching**

```zsh
git branch                      # List branches
git branch <name>               # Create new branch
git checkout <name>             # Switch to branch
git switch <name>               # Switch (modern)
git checkout -b <name>          # Create & switch
```

### 5. `git merge`, `git rebase`

**Integrate changes**

```zsh
git merge <branch>              # Merge branch into current
git rebase <branch>             # Rebase current onto branch
git merge --abort               # Abort a merge
```

### 6. `git pull`, `git push`, `git fetch`

**Sync with remotes**

```zsh
git pull                        # Fetch & merge from remote
git push                        # Push commits to remote
git fetch                       # Download changes, don’t merge
git push -u origin <branch>     # Set upstream for branch
```

### 7. `git stash`, `git reset`, `git revert`

**Undo and recover**

```zsh
git stash                       # Save changes for later
git stash pop                   # Restore stashed changes
git reset --hard HEAD           # Discard all local changes
git reset <file>                # Unstage a file
git revert <commit>             # Create a new commit that undoes a commit
```

### 8. `git log`, `git show`, `git blame`

**History and inspection**

```zsh
git log --author="name"         # Filter by author
git show <commit>               # Show details of a commit
git blame <file>                # Show who changed each line
```

### 9. `git remote`, `git config`, `git tag`

**Remotes, config, and tags**

```zsh
git remote -v                   # List remotes
git remote add origin <url>     # Add a remote
git config --list               # Show config
git tag                         # List tags
git tag <name>                  # Create tag
```

### 10. GitHub CLI (`gh`)

**Interact with GitHub from terminal**

```zsh
gh auth login                   # Authenticate with GitHub
gh repo view                    # View repo info
gh issue list                   # List issues
gh pr create                    # Create a pull request
gh pr checkout <number>         # Checkout a PR branch
gh pr merge <number>            # Merge a PR
```

---

## Common Flags & Shortcuts

- `-a` : All (e.g., `git commit -a`)
- `-m` : Message (e.g., `git commit -m "msg"`)
- `-u` : Set upstream (e.g., `git push -u`)
- `--hard` : Force (e.g., `git reset --hard`)
- `--staged` : Only staged changes (e.g., `git diff --staged`)
- `--oneline` : Compact log (e.g., `git log --oneline`)
- `--graph` : Visual log (e.g., `git log --graph`)
- `--abort` : Abort operation (e.g., `git merge --abort`)

---

## Getting Out of Trouble

### Undo a commit (keep changes)
```zsh
git reset --soft HEAD~1
```

### Undo a commit (discard changes)
```zsh
git reset --hard HEAD~1
```

### Unstage a file
```zsh
git reset <file>
```

### Abort a merge or rebase
```zsh
git merge --abort
git rebase --abort
```

### Recover a deleted branch
```zsh
git reflog                      # Find branch’s last commit
git checkout -b <branch> <commit>
```

### Restore a deleted file
```zsh
git checkout HEAD -- <file>
```

### Fix a bad merge
```zsh
git reset --hard ORIG_HEAD
```

### Find lost commits
```zsh
git reflog                      # Show all recent HEADs
```

### Resolve merge conflicts
- Edit conflicted files, then:
```zsh
git add <file>
git commit
```

---

## Handy Aliases

```zsh
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gco='git checkout'
alias gb='git branch'
alias gpo='git push origin'
```

---

## Resources
- [Git Official Docs](https://git-scm.com/doc)
- [GitHub CLI Docs](https://cli.github.com/manual/)
- [GitHub Help](https://docs.github.com/en)

---

> **Tip:** When in doubt, run `git status` or `git help <command>` for guidance.
