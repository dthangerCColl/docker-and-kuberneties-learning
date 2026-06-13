# Superfile Commands Reference

## Superfile Workflow Overview

Superfile (spf) is a modern, terminal-based file manager with a powerful TUI,
fuzzy navigation, bulk operations, and extensibility. It’s designed for fast
keyboard-driven workflows, supporting panels, plugins, and custom hotkeys.

Typical Superfile workflow:

1. **Install**: Set up superfile and optional plugins
2. **Launch**: Start superfile in your terminal with `spf`
3. **Navigate**: Use hotkeys to move, select, and manage files and panels
4. **Operate**: Perform file operations, search, and use the command prompt
5. **Customize**: Configure hotkeys, themes, plugins, and editors
6. **Extend**: Add plugins for metadata, previews, and more
7. **Maintain**: Update superfile and refine your configuration

---

## Installing Superfile

### macOS (Homebrew)

```bash
brew install yorukot/tap/superfile
```

### Linux (Debian/Ubuntu)

```bash
wget https://github.com/yorukot/superfile/releases/latest/download/superfile-linux-x64.zip
unzip superfile-linux-x64.zip
sudo mv superfile /usr/local/bin/spf
```

### Windows

- Download from [GitHub Releases](https://github.com/yorukot/superfile/releases)
- Add to your PATH as `spf`

---

## Getting Started

- Launch superfile:

```bash
spf
```

- Exit superfile:

```
q
```

or

```
esc
```

---

## 15 Most Used Superfile Hotkeys & Features

### 1. Panel Navigation

- `s` — Focus sidebar
- `p` — Focus processes
- `m` — Focus metadata
- `:` — Open command execution bar
- `f` — Show/hide preview window
- `F` — Show/hide all footer panels

### 2. Panel Management

- `n` — New file panel
- `w` — Close focused file panel
- `tab` or `L` — Next file panel
- `shift+left` or `H` — Previous file panel

### 3. Panel Movement

- `up`/`k` — Move cursor up
- `down`/`j` — Move cursor down
- `enter`/`l` — Open file/folder
- `h`/`backspace` — Go to parent directory
- `P` — Pin/unpin folder to sidebar

### 4. Sorting & Filtering

- `o` — Open sort menu (Name, Size, Date Modified)
- `R` — Reverse sort order
- `/` — Search in current directory
- `.` — Show/hide dotfiles

### 5. Selection Mode

- `v` — Toggle selection mode (like Vim visual mode)
- `enter`/`L` — Select/deselect item
- `K` — Select all above
- `J` — Select all below
- `A` — Select all in directory

### 6. File Operations

- `ctrl+n` — New file/folder
- `ctrl+r` — Rename
- `ctrl+c` — Copy
- `ctrl+x` — Cut
- `ctrl+v` — Paste
- `ctrl+d` — Delete (to trash)
- `ctrl+a` — Compress
- `ctrl+e` — Decompress

### 7. Editor Integration

- `e` — Open file with editor
- `E` — Open current directory with editor

### 8. SPF Prompt

- `:` — Shell mode (run shell commands)
- `>` — SPF mode (run superfile commands)

### 9. Clipboard & Processes

- Clipboard panel shows cut/copied items
- Processes panel shows operation progress

### 10. Metadata Panel

- Focus with `m` for detailed info
- Install metadata plugin for more details

### 11. Sidebar

- Pin folders with `P`
- Navigate sidebar with `s`

### 12. Preview

- Toggle preview with `f`

### 13. Multi-panel Navigation

- `tab`/`L`/`H` to switch panels

### 14. Bulk Operations

- Use selection mode (`v`) for bulk copy, cut, delete

### 15. Customization

- Configure hotkeys, themes, plugins, and editors in config files

---

## Practical Superfile Examples

### Navigation

- Move up/down: `k`/`j` or arrow keys
- Open file/folder: `enter`/`l`
- Go to parent: `h`/`backspace`
- Pin folder: `P`
- Show/hide dotfiles: `.`

### Selection & Bulk Operations

- Enter selection mode: `v`
- Select/deselect: `enter`/`L`
- Select all: `A`
- Copy: `ctrl+c`
- Cut: `ctrl+x`
- Paste: `ctrl+v`
- Delete: `ctrl+d`

### File & Folder Management

- New file/folder: `ctrl+n`
- Rename: `ctrl+r`
- Compress: `ctrl+a`
- Decompress: `ctrl+e`

### Search & Sort

- Search: `/`
- Sort: `o`
- Reverse sort: `R`

### Editor Integration

- Open file: `e`
- Open directory: `E`
- Set default editor: `export EDITOR=nvim` or config file

### SPF Prompt

- Shell mode: `:` then type shell command
- SPF mode: `>` then type SPF command (e.g., `cd ~/Downloads`)

---

## Advanced Usage & Integration

### Plugins

- Enable plugins for metadata, previews, etc.
  ([see docs](https://superfile.dev/configure/enable-plugin))

### Configuration

- Edit config file for hotkeys, themes, plugins
  ([see docs](https://superfile.dev/configure/superfile-config/))
- Set editor: `editor = "nano"` in config
- Set directory editor: `dir_editor = "vi"`

### Custom Hotkeys

- Customize hotkeys in config
  ([see docs](https://superfile.dev/configure/custom-hotkeys/))

### Themes

- Change theme in config
  ([see docs](https://superfile.dev/configure/custom-theme))

### Environment Variables

- Set `EDITOR` for default editor

---

## Troubleshooting & Best Practices

### Common Issues

- **Paste not working**: Some terminals (e.g., Windows Powershell) may intercept
  `ctrl+v`. Remap paste to another hotkey in config.
- **Editor errors**: Ensure your editor supports opening files/directories as
  used by superfile.
- **No output in shell mode**: Shell mode does not show stdout, only exit code.
- **Plugin not working**: Check plugin installation and config.

### Best Practices

1. **Learn hotkeys**: Use the
   [hotkey list](https://superfile.dev/list/hotkey-list/) for reference.
2. **Use selection mode** for bulk operations.
3. **Pin frequently used folders** to the sidebar.
4. **Customize your config** for hotkeys, themes, and plugins.
5. **Update superfile** and plugins regularly.
6. **Backup your config** before major changes.
7. **Use plugins** for enhanced metadata and previews.
8. **Set your preferred editor** for seamless editing.
9. **Check the [troubleshooting guide](https://superfile.dev/troubleshooting)**
   for help.
10. **Contribute or report issues** on
    [GitHub](https://github.com/yorukot/superfile).

---

## Quick Reference Card

| Task                 | Hotkey/Command                 |
| -------------------- | ------------------------------ |
| Launch superfile     | `spf`                          |
| Exit                 | `q` or `esc`                   |
| New file/folder      | `ctrl+n`                       |
| Rename               | `ctrl+r`                       |
| Copy/Cut/Paste       | `ctrl+c` / `ctrl+x` / `ctrl+v` |
| Delete               | `ctrl+d`                       |
| Selection mode       | `v`                            |
| Select all           | `A`                            |
| Open with editor     | `e`                            |
| Open dir with editor | `E`                            |
| Search               | `/`                            |
| Sort                 | `o`                            |
| Pin folder           | `P`                            |
| Toggle preview       | `f`                            |
| SPF prompt           | `:` or `>`                     |
| Next/prev panel      | `tab`/`L`/`H`                  |

---

## Resources

- [Superfile Website](https://superfile.dev/)
- [Getting Started](https://superfile.dev/getting-started/tutorial/)
- [Hotkey List](https://superfile.dev/list/hotkey-list/)
- [Config Guide](https://superfile.dev/configure/superfile-config/)
- [Troubleshooting](https://superfile.dev/troubleshooting)
- [GitHub](https://github.com/yorukot/superfile)
