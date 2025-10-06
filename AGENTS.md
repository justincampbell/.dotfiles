# Claude Context & Rules

## Coding/Working Style (to be moved to a global AGENTS.md)

- Always keep sorted lists sorted (when editing files with sorted lists like plugin configs, imports, dependencies, etc., maintain alphabetical or logical ordering)
- Work on things one at a time, don't jump to the next item without confirming

## Setup Overview
- Dotfiles repo with modular configs
- Neovim with Lazy.nvim plugin management
- Shell setup with custom prompt and functions
- Homebrew for package management, always use Brewfile for reproducibility
- Automated installation via `install.sh`

## Git Conventions
- Prefix commits with tool/category: `vim:`, `shell:`, `git:`, etc.
- Use plain English, no other formatting
- Examples: `vim: Add new plugin`, `shell: Update prompt colors`
- Don't make branches with slashes

## Testing/Validation
- Use `nvim --headless` to check config syntax
- **ALWAYS** use `tmux source-file ~/.tmux.conf` to reload tmux config immediately after making changes
- Most functionality requires user verification
- Run relevant linters when available

## Key Patterns
- Lazy.nvim for plugin management
- Modular Lua configs in `nvim/lua/plugins/`
- Symlinks created by install script
- Git config automation in install script

## Notes
- Proactively work through TODO.md items to help maintain and improve the dotfiles
  - Use markdown checkboxes `- [x]` and `- [ ]` instead of emojis for TODO.md items
- Add new patterns/tools to this file as discovered
- Prefer editing existing files over creating new ones
- Follow existing code style and conventions
- Lazy.nvim plugin cache available at ~/.local/share/nvim/lazy/ for source code/docs
