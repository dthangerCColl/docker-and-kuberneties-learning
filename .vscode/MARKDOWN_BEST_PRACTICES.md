# Markdown Best Practices for AI Agents

## HTML in Markdown - Common Issues

### Problem: Raw HTML Tags in Code Blocks

When creating markdown files, **avoid using raw angle brackets** like `\<TAB\>`,
`\<file\>`, `\<number\>` inside code blocks, as some linters and renderers
interpret them as HTML tags.

### ✅ Solution: Use One of These Alternatives

#### Option 1: Backticks (Recommended)

```bash
ls -`TAB`                       # Show all available flags
git add `file`                  # Add a specific file
docker run `image`:`tag`        # Run a container
```

#### Option 2: Escape with Backslashes

```bash
ls -\<TAB\>                     # Show all available flags
git add \<file\>                # Add a specific file
```

#### Option 3: Use Uppercase Without Brackets

```bash
ls -TAB                         # Show all available flags (implicit)
git add FILE                    # Add a specific file (implicit)
```

---

## Auto-Fix Configuration (Already Set Up)

Your workspace now has:

### 1. `.markdownlint.json` - Linting Rules

- ✅ MD033 enabled: Catches inline HTML
- ✅ MD013 disabled: No line length limit
- ✅ MD036 disabled: Bold text OK (not treated as heading)
- ✅ MD040 disabled: Code blocks don't require language tags

### 2. `.vscode/settings.json` - Auto-Fix on Save

- ✅ `markdownlint.run: "onType"` - Real-time linting
- ✅ `editor.formatOnSave: true` - Auto-format markdown files
- ✅ `source.fixAll.markdownlint: "explicit"` - Auto-fix issues on save

---

## For AI Agents Creating Markdown Files

When generating markdown documentation:

1. **Always use backticks** for placeholder text: `` `TAB` ``, `` `file` ``,
   `` `number` ``
2. **Never use raw angle brackets** in code examples: ❌ `\<TAB\>` → ✅
   `` `TAB` ``
3. **Test the file** after creation by opening it in VS Code (linting will run
   automatically)

---

## Quick Reference

| ❌ Avoid     | ✅ Use Instead           |
| ------------ | ------------------------ |
| `\<TAB\>`    | `` `TAB` `` or `\<TAB\>` |
| `\<file\>`   | `` `file` `` or `FILE`   |
| `\<number\>` | `` `number` `` or `NUM`  |
| `\<url\>`    | `` `url` `` or `URL`     |
| `\<path\>`   | `` `path` `` or `PATH`   |

---

## How It Works Now

1. **Create/edit any `.md` file** in VS Code
2. **Linting runs automatically** as you type
3. **Save the file** (`Cmd+S`) to trigger auto-fix
4. **Check the Problems panel** (`Cmd+Shift+M`) for remaining issues

---

> **Result:** No more HTML linting errors in markdown files! 🎉
