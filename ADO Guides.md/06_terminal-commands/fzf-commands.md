# FZF Commands Reference

## FZF Workflow Overview

FZF (Fuzzy Finder) is a fast, general-purpose command-line fuzzy finder. It helps you quickly search, filter, and select from lists of files, command history, processes, git branches, and more—right inside your terminal.

Typical FZF workflow:

1. **Install**: Set up fzf and optional shell/key bindings
2. **Configure**: Customize fzf options, key bindings, and preview features
3. **Integrate**: Enable fzf in your shell (zsh, bash, fish) and with tools like git, vim, tmux
4. **Use**: Invoke fzf for file search, command history, process selection, etc.
5. **Extend**: Create custom commands, use preview windows, and combine with other CLI tools
6. **Optimize**: Tune performance, shortcuts, and appearance
7. **Maintain**: Update fzf and refine your configuration

---

## Installing FZF

### macOS (Homebrew)

```bash
brew install fzf
```

### Ubuntu/Debian

```bash
sudo apt-get install fzf
```

### Arch Linux

```bash
sudo pacman -S fzf
```

### Manual Install (All Platforms)

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

- The install script enables shell/key bindings and fuzzy completion for your shell.

---

## Shell Integration

- Add the following to your `.zshrc` (or `.bashrc`):

```bash
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

- For bash: `[ -f ~/.fzf.bash ] && source ~/.fzf.bash`
- For fish: `[ -f ~/.fzf.fish ] && source ~/.fzf.fish`

---

## 15 Most Used FZF Commands & Features

### 1. File Search

```bash
fzf                             # Fuzzy-find files in current directory
find . | fzf                    # Search all files recursively
ls | fzf                        # Fuzzy-find from ls output
```

### 2. Command History Search

```bash
history | fzf                   # Search command history
fc -rl 1 | fzf                  # Search and select from recent commands
```

### 3. Directory Navigation

```bash
dirs | fzf                      # Fuzzy-find from directory stack
cd $(find . -type d | fzf)      # cd into selected directory
```

### 4. Git Integration

```bash
git checkout $(git branch | fzf)    # Fuzzy-select branch
git log --oneline | fzf             # Search commits
git stash list | fzf                # Search stashes
```

### 5. Process Management

```bash
ps aux | fzf                        # Fuzzy-find process
kill $(ps aux | fzf | awk '{print $2}')  # Kill selected process
```

### 6. Preview Window

```bash
fzf --preview 'cat {}'              # Preview file contents
fzf --preview 'head -100 {}'        # Preview first 100 lines
```

### 7. Key Bindings

- `Ctrl+T`: Fuzzy-find files and insert path at cursor
- `Ctrl+R`: Fuzzy-search command history
- `Alt+C`: Fuzzy cd into selected directory

### 8. Fuzzy Completion

- Type part of a filename, then press `Tab` for fuzzy completion (if enabled)

### 9. Filtering and Sorting

```bash
fzf --reverse                     # Show results in reverse order
fzf --height 40%                  # Limit result window height
fzf --sort                        # Sort results alphabetically
```

### 10. Multi-Select

```bash
fzf --multi                       # Enable multi-select (Tab to select)
```

### 11. Custom Key Bindings

```bash
fzf --bind 'ctrl-a:select-all,ctrl-d:deselect-all'
```

### 12. Search with Preview and Actions

```bash
fzf --preview 'bat --style=numbers --color=always {}' --bind 'enter:execute(nvim {})'
```

### 13. Integration with Other Tools

```bash
rg --files | fzf                 # Use ripgrep for file list
fd . | fzf                       # Use fd for fast file search
```

### 14. Environment Variables

```bash
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
```

### 15. Scripting and Functions

```bash
fcd() { cd "$(find . -type d | fzf)" }
fkill() { kill -9 $(ps aux | fzf | awk '{print $2}') }
```

---

## Practical FZF Examples

### File Search

```bash
# Fuzzy-find files in current directory
fzf

# Find files recursively and open with vim
vim $(find . -type f | fzf)

# Search for .md files only
find . -name "*.md" | fzf

# Use ripgrep for fast file search
rg --files | fzf
```

### Command History Search

```bash
# Search and run previous commands
history | fzf

# With key binding (Ctrl+R)
# Press Ctrl+R in shell to open fzf history search, select, and run

# Search for docker commands in history
history | grep docker | fzf
```

### Directory Navigation

```bash
# Fuzzy cd into a directory
cd $(find . -type d | fzf)

# With key binding (Alt+C)
# Press Alt+C to fuzzy cd into a directory (if enabled)
```

### Git Integration

```bash
# Checkout a branch using fzf
git checkout $(git branch | fzf)

# Search and view commit logs
git log --oneline | fzf

# Fuzzy-select a stash to apply
git stash list | fzf | awk '{print $1}' | xargs git stash apply
```

### Process Management

```bash
# Fuzzy-find and kill a process
ps aux | fzf | awk '{print $2}' | xargs kill -9
```

---

## Advanced FZF Usage & Integration

### Key Bindings

- **Ctrl+T**: Fuzzy-find files and insert path at cursor
- **Ctrl+R**: Fuzzy-search command history
- **Alt+C**: Fuzzy cd into selected directory

> These are enabled by sourcing `~/.fzf.zsh` in your `.zshrc`.

### Preview Window

```bash
fzf --preview 'cat {}'                  # Show file contents
fzf --preview 'bat --style=numbers --color=always {}'  # Use bat for syntax highlighting
fzf --preview 'git diff {}'             # Preview git diff for selected file
```

### Custom Commands & Functions

```bash
# Fuzzy cd function
fcd() { cd "$(find . -type d | fzf)" }

# Fuzzy kill function
fkill() { kill -9 $(ps aux | fzf | awk '{print $2}') }

# Fuzzy open file in editor
fo() { vim "$(fzf)" }
```

### Integration with Zsh & Oh My Zsh

- Add `[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh` to `.zshrc`
- Oh My Zsh users: Add fzf plugin for enhanced integration
- Use aliases and functions in `.zshrc` for custom workflows

### Environment Variables

```bash
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
```

### Using fzf with Other Tools

```bash
# Use with ripgrep
rg --files | fzf

# Use with fd
fd . | fzf

# Use with ag (the silver searcher)
ag -g "" | fzf
```

---

## Troubleshooting Common Issues

### Key Bindings Not Working

```bash
# Ensure ~/.fzf.zsh is sourced in your .zshrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Restart your terminal after installation
exec zsh
```

### Slow Performance

```bash
# Use fd or rg for faster file listing
export FZF_DEFAULT_COMMAND='fd --type f'
# Or
export FZF_DEFAULT_COMMAND='rg --files'
```

### Preview Not Displaying

```bash
# Ensure preview command is valid and installed (e.g., bat, cat)
fzf --preview 'bat {}'
```

### Fuzzy Completion Not Working

```bash
# Re-run install script to enable completion
~/.fzf/install

# Check shell integration
source ~/.fzf.zsh
```

### No Results Found

```bash
# Check your FZF_DEFAULT_COMMAND
echo $FZF_DEFAULT_COMMAND
# Try a simpler command: export FZF_DEFAULT_COMMAND='find .'
```

---

## Best Practices

1. **Use fast file listers**: Prefer `fd` or `rg` over `find` for speed.
2. **Customize appearance**: Set `FZF_DEFAULT_OPTS` for layout, colors, and height.
3. **Integrate with your shell**: Source fzf scripts in `.zshrc` or `.bashrc`.
4. **Create aliases/functions**: For common fuzzy workflows (cd, kill, open).
5. **Use preview windows**: For context when searching files or git objects.
6. **Update regularly**: Keep fzf and plugins up to date.
7. **Modular config**: Store custom fzf functions in a separate file and source it.
8. **Backup config**: Save your `.fzf.zsh` and related scripts.
9. **Security**: Avoid running untrusted preview commands.
10. **Performance**: Profile and optimize your default command for large projects.

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Fuzzy-find files | `fzf` |
| Fuzzy cd | `cd $(find . -type d | fzf)` |
| Fuzzy kill process | `ps aux | fzf | awk '{print $2}' | xargs kill -9` |
| Fuzzy git checkout | `git checkout $(git branch | fzf)` |
| Fuzzy history | `history | fzf` |
| Preview file | `fzf --preview 'cat {}'` |
| Multi-select | `fzf --multi` |
| Key bindings | `Ctrl+T`, `Ctrl+R`, `Alt+C` |
| Custom command | `fcd() { cd "$(find . -type d | fzf)" }` |

---

## Resources

- [fzf GitHub](https://github.com/junegunn/fzf)
- [fzf Wiki](https://github.com/junegunn/fzf/wiki)
- [fzf Awesome](https://github.com/junegunn/fzf#awesome-fzf)
