# Zsh Commands Reference

## Zsh Workflow Overview

Zsh (Z Shell) is a powerful Unix shell that extends the Bourne shell with numerous improvements, including better tab completion, advanced globbing, plugins, and themes. The typical Zsh workflow follows these stages:

1. **Install**: Set up Zsh as your default shell
2. **Configure**: Create and customize your `.zshrc` configuration file
3. **Enhance**: Install frameworks like Oh My Zsh or plugins for additional functionality
4. **Customize**: Add aliases, functions, and environment variables
5. **Optimize**: Configure completion systems and prompt themes
6. **Extend**: Add plugins for git, syntax highlighting, autosuggestions
7. **Maintain**: Update plugins and refine configurations over time

### Zsh with Oh My Zsh

Oh My Zsh is a popular framework for managing Zsh configuration. It comes with hundreds of plugins and themes, making it easy to customize your shell experience. Powerlevel10k is a highly customizable theme that provides a beautiful and informative prompt.

---

## 15 Most Used Zsh Commands & Features

### 1. `cd` (Enhanced Directory Navigation)

**Navigate directories with powerful shortcuts**

```bash
cd /path/to/directory           # Standard directory change
cd -                            # Return to previous directory
cd ~                            # Go to home directory
cd ../..                        # Go up two levels
cd /u/l/b                       # Tab completion expands to /usr/local/bin
cd **/*pattern*                 # Recursive search with globbing
cd =command                     # Jump to command location
```

### 2. Tab Completion

**Advanced auto-completion system**

```bash
ls -<TAB>                       # Show all available flags
git <TAB>                       # Show git subcommands
ssh <TAB>                       # Show known hosts from ~/.ssh/config
kill <TAB>                      # Show running processes
cd ~<TAB>                       # Show user home directories
docker <TAB>                    # Show docker commands and containers

# Smart completion
ls *.txt<TAB>                   # Complete only .txt files
cd ~/D<TAB>                     # Case-insensitive completion
```

### 3. `alias`

**Create command shortcuts**

```bash
alias                           # List all aliases
alias ll='ls -lah'              # Create new alias
alias gs='git status'           # Git shortcut
alias ..='cd ..'                # Quick navigation
alias ...='cd ../..'            # Go up two levels
alias grep='grep --color=auto'  # Always colorize grep
alias python='python3'          # Default to Python 3

# Remove alias
unalias ll

# Temporary disable alias
\ls                             # Run original ls without alias
```

### 4. `history`

**Command history management**

```bash
history                         # Show command history
history 20                      # Show last 20 commands
history | grep docker           # Search history
!!                              # Repeat last command
!$                              # Last argument of previous command
!*                              # All arguments of previous command
!-2                             # Command from 2 entries ago
!docker                         # Most recent command starting with docker
^old^new                        # Replace 'old' with 'new' in last command

# Reverse search
Ctrl+R                          # Search backward through history
Ctrl+S                          # Search forward through history
```

### 5. Globbing & Pattern Matching

**Advanced file matching patterns**

```bash
ls **/*.js                      # Recursively list all .js files
ls *.{js,ts,tsx}                # Match multiple extensions
ls file[0-9].txt                # Match file0.txt through file9.txt
ls file<1-100>.txt              # Numeric range matching
ls *~*.bak                      # All files except .bak files
ls -ld **/*(/)                  # List all directories recursively
ls -l **/*.js(.)                # List only files (not directories)
ls -l *(.x)                     # List only executable files
ls -l *(m-7)                    # Files modified in last 7 days
ls -l *(Lk+100)                 # Files larger than 100KB
```

### 6. `zmv` (Batch File Renaming)

**Powerful pattern-based file renaming**

```bash
# Enable zmv (add to .zshrc)
autoload -U zmv

# Basic renaming
zmv '(*).txt' '$1.md'           # Rename all .txt to .md
zmv '(*)' '${(L)1}'             # Convert all filenames to lowercase
zmv '(*)' '${(C)1}'             # Capitalize all filenames
zmv 'file(*).txt' 'document$1.txt'  # Rename file*.txt to document*.txt

# Advanced examples
zmv -n '(*).txt' '$1.md'        # Dry run (show what would happen)
zmv -w '*.txt' '*.md'           # Wildcard mode (simpler syntax)
zmv '(*)-(*).txt' '$2-$1.txt'   # Swap parts of filename
```

### 7. `setopt` (Shell Options)

**Configure Zsh behavior**

```bash
setopt                          # Show all set options
setopt AUTO_CD                  # cd by typing directory name
setopt CORRECT                  # Suggest corrections for typos
setopt EXTENDED_GLOB            # Enable extended globbing
setopt HIST_IGNORE_DUPS         # Don't save duplicate commands
setopt SHARE_HISTORY            # Share history across terminals
setopt AUTO_PUSHD               # Make cd push to directory stack
setopt PUSHD_IGNORE_DUPS        # Don't push duplicates

# Unset option
unsetopt BEEP                   # Disable beep sound
```

### 8. Directory Stack

**Navigate directory history**

```bash
pushd /path/to/dir              # Push directory to stack and cd to it
popd                            # Return to previous directory
dirs -v                         # Show directory stack with numbers
cd ~3                           # Jump to directory #3 in stack
cd -                            # Toggle between last two directories

# Auto pushd (add to .zshrc)
setopt AUTO_PUSHD               # Automatically push directories
setopt PUSHD_IGNORE_DUPS        # Don't push duplicates
```

### 9. `autoload` (Load Shell Functions)

**Load built-in Zsh functions**

```bash
autoload -Uz compinit && compinit  # Initialize completion system
autoload -U colors && colors    # Enable color support
autoload -U zmv                 # Enable zmv for batch renaming
autoload -Uz vcs_info           # Version control info in prompt
autoload -U promptinit          # Initialize prompt system

# Add to .zshrc for persistent loading
```

### 10. Parameter Expansion

**Advanced variable manipulation**

```bash
file="document.txt"
echo ${file%.txt}               # Remove .txt extension -> "document"
echo ${file%.*}                 # Remove any extension -> "document"
echo ${file#*/}                 # Remove path up to / -> "document.txt"
echo ${file:u}                  # Uppercase -> "DOCUMENT.TXT"
echo ${file:l}                  # Lowercase -> "document.txt"
echo ${#file}                   # String length -> 12

# Array manipulation
arr=(one two three)
echo ${arr[1]}                  # First element (1-indexed)
echo ${arr[@]}                  # All elements
echo ${#arr[@]}                 # Array length
echo ${arr[@]:1:2}              # Slice: elements 2-3
```

### 11. `source` / `.`

**Load configuration files**

```bash
source ~/.zshrc                 # Reload Zsh configuration
. ~/.zshrc                      # Same as source (shorter)
source ~/.zsh/aliases.zsh       # Load custom aliases file
source ~/.zsh/functions.zsh     # Load custom functions

# Common usage after editing config
vim ~/.zshrc
source ~/.zshrc                 # Apply changes
```

### 12. `which` / `whence`

**Locate commands and show information**

```bash
which python                    # Show path to python command
which -a python                 # Show all python locations in PATH
whence -v python                # Verbose: show if alias/function/command
whence -w python                # Show type of command
type python                     # Show all information about command

# Check if command exists
if (( $+commands[docker] )); then
  echo "Docker is installed"
fi
```

### 13. `fc` (Fix Command)

**Edit and re-run previous commands**

```bash
fc                              # Open last command in editor
fc -l                           # List recent commands (like history)
fc -l 10 20                     # List commands 10-20
fc 15                           # Edit command #15 in editor
fc -e nano                      # Use nano as editor
fc -s                           # Re-run last command
fc -s docker                    # Re-run last docker command
```

### 14. `jobs` / `fg` / `bg`

**Job control and background processes**

```bash
jobs                            # List background jobs
jobs -l                         # List jobs with PIDs
command &                       # Run command in background
Ctrl+Z                          # Suspend current job

fg                              # Bring most recent job to foreground
fg %1                           # Bring job #1 to foreground
bg                              # Resume suspended job in background
bg %2                           # Resume job #2 in background
kill %1                         # Kill job #1
disown %1                       # Remove job from job table
```

### 15. `bindkey`

**Keyboard shortcut configuration**

```bash
bindkey                         # List all key bindings
bindkey -L                      # List in form that can be reused
bindkey '^A' beginning-of-line  # Ctrl+A to go to line start
bindkey '^E' end-of-line        # Ctrl+E to go to line end
bindkey '^R' history-incremental-search-backward  # Ctrl+R search
bindkey '^[[A' up-line-or-search  # Up arrow for history search

# Vi mode
bindkey -v                      # Enable vi mode
bindkey -e                      # Enable emacs mode (default)
```

---

## Additional Useful Commands

### Shell Navigation

```bash
take() { mkdir -p "$1" && cd "$1"; }  # Create and enter directory
.. () { cd ..; }                # Quick parent directory
... () { cd ../..; }            # Two levels up
d                               # Show directory stack (with oh-my-zsh)
1-9                             # Jump to directory in stack (with oh-my-zsh)
```

### Text Processing

```bash
grep -r "pattern" .             # Recursive search
awk '{print $1}' file.txt       # Print first column
sed 's/old/new/g' file.txt      # Replace text
cut -d',' -f1 file.csv          # Extract CSV column
sort file.txt                   # Sort lines
uniq file.txt                   # Remove duplicates
wc -l file.txt                  # Count lines
```

### File Operations

```bash
cp -r source/ dest/             # Copy directory recursively
mv old.txt new.txt              # Rename/move file
rm -rf directory/               # Remove directory forcefully
ln -s target link               # Create symbolic link
chmod +x script.sh              # Make file executable
chown user:group file           # Change ownership
find . -name "*.js"             # Find files by name
```

### System Information

```bash
ps aux                          # List all processes
top                             # Real-time process monitor
htop                            # Better process monitor (if installed)
df -h                           # Disk usage
du -sh *                        # Directory sizes
free -h                         # Memory usage (Linux)
uptime                          # System uptime
uname -a                        # System information
```

---

## Zsh Configuration File Structure

### Basic .zshrc Example

```bash
# ~/.zshrc - Main Zsh configuration file

# ==========================================
# Path Configuration
# ==========================================
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# ==========================================
# Oh My Zsh Configuration
# ==========================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  docker
  kubectl
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

# ==========================================
# History Configuration
# ==========================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt EXTENDED_HISTORY          # Write timestamp to history
setopt HIST_IGNORE_DUPS          # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicate entries
setopt HIST_FIND_NO_DUPS         # Don't display duplicates in search
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt SHARE_HISTORY             # Share history between sessions

# ==========================================
# Completion Configuration
# ==========================================
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select                           # Select completions with arrows
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'         # Case-insensitive completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # Colored completion
zstyle ':completion:*' rehash true                          # Auto-rehash for new commands
zstyle ':completion:*' accept-exact '*(N)'                  # Speed up completion
zstyle ':completion:*' use-cache on                         # Use completion cache
zstyle ':completion:*' cache-path ~/.zsh/cache              # Cache location

# ==========================================
# Shell Options
# ==========================================
setopt AUTO_CD                   # cd by typing directory name
setopt AUTO_PUSHD                # Push directories to stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_SILENT              # Don't print directory stack
setopt CORRECT                   # Suggest corrections
setopt EXTENDED_GLOB             # Extended pattern matching
setopt GLOB_DOTS                 # Include dotfiles in glob
setopt NO_BEEP                   # Disable beep
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shell

# ==========================================
# Key Bindings
# ==========================================
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
bindkey '^[[H' beginning-of-line                # Home key
bindkey '^[[F' end-of-line                      # End key
bindkey '^[[3~' delete-char                     # Delete key
bindkey '^H' backward-kill-word                 # Ctrl+Backspace

# ==========================================
# Aliases
# ==========================================
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ls aliases
alias ls='ls --color=auto'       # Linux
alias ls='ls -G'                 # macOS
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --all'
alias gd='git diff'
alias gco='git checkout'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kl='kubectl logs -f'

# System aliases
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %T"'
alias ports='netstat -tulanp'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ==========================================
# Custom Functions
# ==========================================

# Create directory and cd into it
take() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick search
qf() {
  find . -iname "*$1*"
}

# Quick grep
qg() {
  grep -r "$1" .
}

# Git commit and push
gcp() {
  git add .
  git commit -m "$1"
  git push
}

# ==========================================
# Environment Variables
# ==========================================
export EDITOR='vim'
export VISUAL='vim'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Node.js
export NODE_ENV='development'

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Python
export PYTHONDONTWRITEBYTECODE=1

# ==========================================
# Load Additional Config Files
# ==========================================
[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh
[ -f ~/.zsh/functions.zsh ] && source ~/.zsh/functions.zsh
[ -f ~/.zsh/work.zsh ] && source ~/.zsh/work.zsh

# Load local config (not in version control)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ==========================================
# Initialize Tools
# ==========================================
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Homebrew completions (macOS)
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# FZF (Fuzzy Finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ==========================================
# Powerlevel10k Instant Prompt
# ==========================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

### Modular Configuration Structure

```
~/.zsh/
  ├── aliases.zsh        # All aliases
  ├── functions.zsh      # Custom functions
  ├── completion.zsh     # Completion settings
  ├── keybindings.zsh    # Key bindings
  ├── prompt.zsh         # Prompt configuration
  └── plugins/           # Custom plugins
```

---

## Oh My Zsh Features

With Oh My Zsh installed:

- 300+ plugins for various tools and languages
- 150+ themes for prompt customization
- Auto-update mechanism for plugins and core
- Plugin manager with easy enable/disable
- Consistent plugin API
- Community-driven development

### Installing Oh My Zsh

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Or with wget
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

### Popular Plugins

```bash
# In ~/.zshrc, add to plugins array:
plugins=(
  git                        # Git aliases and functions
  docker                     # Docker completion
  docker-compose             # Docker Compose completion
  kubectl                    # Kubernetes completion
  terraform                  # Terraform completion
  aws                        # AWS CLI completion
  npm                        # npm completion
  node                       # Node.js utilities
  python                     # Python utilities
  vscode                     # VS Code shortcuts
  zsh-autosuggestions        # Fish-like suggestions
  zsh-syntax-highlighting    # Syntax highlighting
  history-substring-search   # Better history search
  colored-man-pages          # Colorized man pages
  copypath                   # Copy file path to clipboard
  copyfile                   # Copy file contents to clipboard
  jsontools                  # JSON formatting tools
  web-search                 # Search from terminal
)
```

### Installing Additional Plugins

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Add to plugins array in ~/.zshrc
plugins=(... zsh-autosuggestions zsh-syntax-highlighting)
```

---

## Best Practices

1. **Modular configuration**: Split `.zshrc` into multiple files for easier management
2. **Version control**: Keep your dotfiles in git (exclude sensitive data)
3. **Comments**: Document your configuration for future reference
4. **Performance**: Lazy-load heavy tools and use caching for completions
5. **Aliases**: Use descriptive names and avoid overriding system commands
6. **Functions over aliases**: Use functions for complex operations
7. **Test changes**: Source `.zshrc` after changes to catch errors
8. **Backup**: Keep backups before major configuration changes
9. **Security**: Don't source untrusted scripts or add unsafe paths
10. **Updates**: Regularly update Oh My Zsh and plugins

### Performance Optimization

```bash
# Lazy load NVM (much faster startup)
nvm() {
  unset -f nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Skip compinit for faster startup (run manually when needed)
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Profile startup time
zmodload zsh/zprof
# ... rest of .zshrc ...
zprof  # Show profiling results
```

### Dotfiles Management

```bash
# Create dotfiles repository
mkdir ~/dotfiles
cd ~/dotfiles
git init

# Move config files
mv ~/.zshrc ~/dotfiles/zshrc
ln -s ~/dotfiles/zshrc ~/.zshrc

# Track in git
git add .
git commit -m "Initial dotfiles"
git remote add origin <your-repo-url>
git push -u origin main
```

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Reload config | `source ~/.zshrc` |
| Edit config | `vim ~/.zshrc` |
| Show aliases | `alias` |
| Create alias | `alias name='command'` |
| Show history | `history` |
| Search history | `Ctrl+R` |
| Last command | `!!` |
| Last argument | `!$` |
| List files recursively | `ls **/*.txt` |
| Rename files | `zmv '*.txt' '*.md'` |
| Show directory stack | `dirs -v` |
| Jump to directory | `cd ~3` |
| Background job | `command &` |
| List jobs | `jobs` |
| Bring to foreground | `fg %1` |
| Tab completion | `<TAB>` |

---

## Troubleshooting Common Issues

### Zsh Not Default Shell

```bash
# Check current shell
echo $SHELL

# List available shells
cat /etc/shells

# Change default shell to Zsh
chsh -s $(which zsh)

# Or specify path directly
chsh -s /bin/zsh
```

### Slow Startup Time

```bash
# Profile startup
zsh -xv 2>&1 | ts -i '%.s' | tee /tmp/zsh-profile.log

# Or use zprof
echo 'zmodload zsh/zprof' >> ~/.zshrc
# ... rest of config ...
echo 'zprof' >> ~/.zshrc

# Identify slow plugins and lazy-load them
```

### Completion Not Working

```bash
# Rebuild completion cache
rm -f ~/.zcompdump
compinit

# Check if compinit is loaded
autoload -Uz compinit && compinit

# Fix permissions
chmod 755 ~/.oh-my-zsh
chmod 755 ~/.oh-my-zsh/custom
compaudit | xargs chmod g-w
```

### Oh My Zsh Update Issues

```bash
# Manual update
omz update

# Check for updates
omz update --check

# Disable auto-updates
zstyle ':omz:update' mode disabled

# Set update frequency (in days)
zstyle ':omz:update' frequency 7
```

### Plugin Not Loading

```bash
# Check plugin exists
ls $ZSH_CUSTOM/plugins/

# Verify plugins array in .zshrc
echo $plugins

# Check for errors when sourcing
zsh -xv

# Try loading plugin manually
source $ZSH_CUSTOM/plugins/plugin-name/plugin-name.plugin.zsh
```

### Permission Denied Errors

```bash
# Fix Oh My Zsh permissions
compaudit | xargs chmod g-w,o-w

# Fix cache directory
chmod 755 ~/.zsh/cache

# Fix completion directory
chmod -R 755 /usr/local/share/zsh
```

---

## Advanced Zsh Features

### Suffix Aliases

```bash
# Open files with specific programs by typing filename
alias -s txt=vim
alias -s pdf=open
alias -s {jpg,png,gif}=open
alias -s zip=unzip
alias -s gz='tar -xzf'

# Now just type: file.txt (opens in vim)
```

### Global Aliases

```bash
# Can be used anywhere in command line
alias -g L='| less'
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g N='> /dev/null 2>&1'
alias -g J='| jq'

# Usage: command L (pipe to less)
# Usage: command G 'pattern' (pipe to grep)
```

### Hooks

```bash
# Function runs before each command
preexec() {
  echo "Executing: $1"
}

# Function runs before prompt
precmd() {
  # Set terminal title to current directory
  print -Pn "\e]0;%~\a"
}

# Run command when changing directory
chpwd() {
  ls -la
}
```

### Named Directories

```bash
# Create named directory
hash -d proj=~/projects/myproject

# Usage
cd ~proj
ls ~proj
```

### Arrays

```bash
# Create array
colors=(red green blue)

# Access elements (1-indexed)
echo $colors[1]        # red
echo $colors[@]        # all elements
echo $colors[-1]       # last element

# Array operations
colors+=(yellow)       # Append
colors[2]=orange       # Replace
echo ${#colors[@]}     # Length
echo ${colors[@]:1:2}  # Slice
```

---

## Useful Zsh Tools & Enhancements

### Powerlevel10k Theme

```bash
# Install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set in ~/.zshrc
ZSH_THEME="powerlevel10k/powerlevel10k"

# Configure
p10k configure
```

### FZF (Fuzzy Finder)

```bash
# Install
brew install fzf

# Setup key bindings and completion
$(brew --prefix)/opt/fzf/install

# Usage
Ctrl+R                 # Search history
Ctrl+T                 # Search files
Alt+C                  # Change directory
```

### Zoxide (Smarter cd)

```bash
# Install
brew install zoxide

# Add to ~/.zshrc
eval "$(zoxide init zsh)"

# Usage
z documents            # Jump to documents directory
zi                     # Interactive selection
```

### exa (Modern ls)

```bash
# Install
brew install exa

# Alias in ~/.zshrc
alias ls='exa'
alias ll='exa -lah --git'
alias tree='exa --tree'
```

### bat (Better cat)

```bash
# Install
brew install bat

# Alias
alias cat='bat'
```

---

## Zsh vs Bash Differences

| Feature | Zsh | Bash |
|---------|-----|------|
| Array indexing | 1-based | 0-based |
| Extended globbing | Built-in | Requires shopt |
| Right prompt | Yes | No |
| Spelling correction | Yes | Limited |
| Theme support | Extensive | Basic |
| Plugin system | Oh My Zsh, etc. | Limited |
| Tab completion | Advanced | Basic |
| Substring search | Built-in | Requires setup |

---

## Environment-Specific Configurations

### macOS Specific

```bash
# ~/.zshrc additions for macOS

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Open apps
alias chrome='open -a "Google Chrome"'
alias code='open -a "Visual Studio Code"'

# macOS commands
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
```

### Linux Specific

```bash
# ~/.zshrc additions for Linux

# Package management
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'

# System info
alias sys='inxi -Fxz'
```

---

## Migration from Bash

### Converting .bashrc to .zshrc

```bash
# Most bash syntax works in zsh
# Main differences:

# Arrays (bash: 0-indexed, zsh: 1-indexed)
# Bash: ${array[0]}
# Zsh:  ${array[1]}

# Source commands work the same
source ~/.bash_aliases

# Functions work the same
function_name() {
  # code
}

# Export variables work the same
export VARIABLE="value"
```

### Testing Compatibility

```bash
# Test if running in zsh
if [ -n "$ZSH_VERSION" ]; then
  echo "Running in Zsh"
elif [ -n "$BASH_VERSION" ]; then
  echo "Running in Bash"
fi
```

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+A` | Move to beginning of line |
| `Ctrl+E` | Move to end of line |
| `Ctrl+U` | Delete from cursor to beginning |
| `Ctrl+K` | Delete from cursor to end |
| `Ctrl+W` | Delete word before cursor |
| `Ctrl+R` | Reverse history search |
| `Ctrl+L` | Clear screen |
| `Ctrl+Z` | Suspend current process |
| `Ctrl+C` | Kill current process |
| `Ctrl+D` | Exit shell (if line empty) |
| `Alt+.` | Insert last argument |
| `Alt+B` | Move back one word |
| `Alt+F` | Move forward one word |
