# fd Terminal Commands Reference

## fd Workflow Overview

`fd` is a blazing-fast, user-friendly alternative to `find` for searching files and directories from the command line. It features intuitive syntax, smart-case matching, colorized output, parallel execution, and seamless integration with other tools.

Typical fd workflow:

1. **Install**: Set up fd for your platform
2. **Search**: Use simple patterns or regular expressions to find files/directories
3. **Filter**: Use options to filter by type, extension, size, owner, etc.
4. **Operate**: Execute commands on search results (copy, delete, open, etc.)
5. **Integrate**: Use fd with fzf, xargs, tree, rofi, emacs, and more
6. **Customize**: Set up shell completions, color schemes, and ignore rules
7. **Maintain**: Update fd and refine your workflow

---

## Installing fd

### macOS (Homebrew)

```bash
brew install fd
```

### Ubuntu/Debian

```bash
sudo apt install fd-find
# Optionally, symlink to 'fd' for convenience:
ln -s $(which fdfind) ~/.local/bin/fd
```

### Arch Linux

```bash
sudo pacman -S fd
```

### Fedora

```bash
dnf install fd-find
```

### Windows

- Download from [GitHub Releases](https://github.com/sharkdp/fd/releases)
- Or use Scoop: `scoop install fd`
- Or Chocolatey: `choco install fd`
- Or Winget: `winget install sharkdp.fd`

### From Source (any platform)

```bash
cargo install fd-find
```

---

## 15 Most Used fd Commands & Features

### 1. Simple Search

```bash
fd pattern
```

Find files/directories matching `pattern` recursively from the current directory.

### 2. Regular Expression Search

```bash
fd '^x.*rc$' /etc
```

Search for entries starting with 'x' and ending with 'rc' in /etc.

### 3. Search in a Specific Directory

```bash
fd passwd /etc
```

### 4. List All Files Recursively

```bash
fd
```

### 5. Search by Extension

```bash
fd -e md
```

Find all Markdown files.

### 6. Glob-based Search

```bash
fd -g '*.py'
```

Find all Python files using glob patterns.

### 7. Show Hidden and Ignored Files

```bash
fd -H -I pattern
```

Show hidden files and ignore .gitignore rules.

### 8. Match Full Path

```bash
fd -p 'src/.*/main.rs'
```

### 9. Filter by Type

```bash
fd -t d
```

Find directories only. Use `-t f` for files, `-t l` for symlinks, etc.

### 10. Exclude Files/Directories

```bash
fd pattern -E node_modules -E '*.bak'
```

### 11. Execute Command for Each Result

```bash
fd -e zip -x unzip
```

Unzip all zip files found.

### 12. Execute Command in Batch

```bash
fd -g 'test_*.py' -X vim
```

Open all test Python files in a single vim instance.

### 13. List Details (ls-like Output)

```bash
fd -l
```

### 14. Delete Files

```bash
fd -H '^\.DS_Store$' -tf -X rm
```

Delete all .DS_Store files (be careful!).

### 15. Integration with fzf

```bash
export FZF_DEFAULT_COMMAND='fd --type f'
```

Use fd as the default source for fzf.

---

## Practical fd Examples

### Find All JPEG Images in Home Directory

```bash
fd -e jpg . ~
```

### Find and Open All Markdown Files in VS Code

```bash
fd -e md -X code
```

### Find All Files Modified in the Last 7 Days

```bash
fd --changed-within 7d
```

### Find Large Files (>100MB)

```bash
fd -S +100M
```

### Find and Delete All Backup Files

```bash
fd -E '*.bak' -X rm
```

### Find All Files Owned by a User

```bash
fd -o username
```

### Find and Print as a Tree

```bash
fd | tree --fromfile
```

---

## Advanced Usage & Integration

### Command Execution Placeholders

- `{}`: Full path
- `{.}`: Path without extension
- `{/}`: Basename
- `{//}`: Parent directory
- `{/.}`: Basename without extension

### Parallel vs Serial Execution

- `-x` runs commands in parallel (default)
- `-X` runs command once with all results (batch)
- Use `-j N` to set number of threads

### Ignore Files

- Use `.fdignore` or `~/.config/fd/ignore` for global rules

### Shell Completions

- Bash: source `fd.bash` in `.bashrc`
- Zsh: move `_fd` to a directory in `$fpath`
- Fish: put `fd.fish` in `~/.config/fish/completions`

### Integration with Other Tools

- **fzf**: `export FZF_DEFAULT_COMMAND='fd --type f'`
- **rofi**: `fd --type f | rofi -dmenu`
- **emacs**: `(setq ffip-use-rust-fd t)` in config
- **tree**: `fd | tree --fromfile`
- **xargs/parallel**: `fd -0 -e rs | xargs -0 wc -l`

---

## Troubleshooting & Best Practices

### Common Issues

- **Not finding files?** Use `-u` to search hidden/ignored files, or `-HI`.
- **Regex not matching?** Quote your pattern: `fd '^[A-Z][0-9]+$'`
- **Pattern starts with dash?** Use `--` before the pattern: `fd -- '-pattern'`
- **Color output not working?** Set `LS_COLORS` or use vivid/dircolors.
- **Command not found for aliases/functions?** Use a shell script or export the function.

### Best Practices

1. **Use simple patterns** for most searches.
2. **Leverage extensions and types** for fast filtering.
3. **Integrate with fzf** for fuzzy finding.
4. **Use .fdignore** to skip unwanted files globally.
5. **Batch operations** with `-X` for efficiency.
6. **Always preview before deleting** with `fd ...` before `fd ... -X rm`.
7. **Update fd** regularly for new features.
8. **Customize completions** for your shell.
9. **Use colorized output** for clarity.
10. **Check the [troubleshooting guide](https://github.com/sharkdp/fd#troubleshooting)** for help.

---

## Quick Reference Card

| Task | Command/Option |
|------|---------------|
| Simple search | `fd pattern` |
| Regex search | `fd '^x.*rc$'` |
| Search in dir | `fd pattern /path` |
| By extension | `fd -e md` |
| By type | `fd -t d` |
| Show hidden | `fd -H` |
| No ignore | `fd -I` |
| Exclude | `fd -E pattern` |
| Full path match | `fd -p` |
| Exec per result | `fd -x cmd` |
| Exec batch | `fd -X cmd` |
| List details | `fd -l` |
| Delete files | `fd ... -X rm` |
| fzf integration | `export FZF_DEFAULT_COMMAND='fd --type f'` |

---

## Resources

- [fd GitHub Repo](https://github.com/sharkdp/fd)
- [fd Releases](https://github.com/sharkdp/fd/releases)
- [fd README](https://github.com/sharkdp/fd#readme)
- [fzf](https://github.com/junegunn/fzf)
- [vivid (LS_COLORS)](https://github.com/sharkdp/vivid)
- [Troubleshooting](https://github.com/sharkdp/fd#troubleshooting)
