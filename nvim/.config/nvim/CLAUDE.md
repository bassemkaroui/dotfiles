# Neovim Configuration

Customized Kickstart.nvim configuration with extensive Python development support.

## Project Overview

This is a personal Neovim configuration based on Kickstart.nvim, extended with 57+ custom plugins for Python development, Git workflows, and productivity.

## Tech Stack

| Component      | Technology                               |
| -------------- | ---------------------------------------- |
| Plugin Manager | Lazy.nvim                                |
| Completion     | Blink.cmp                                |
| LSP            | nvim-lspconfig + Mason                   |
| Formatting     | Conform.nvim + None-LS                   |
| Linting        | Ruff (Python), nvim-lint                 |
| Syntax         | Treesitter                               |
| Fuzzy Finder   | Telescope + FZF                          |
| File Explorer  | Neo-tree, Yazi                           |
| Git            | Gitsigns, Neogit, Git-worktree, Fugitive |
| Debug          | DAP (nvim-dap)                           |
| Theme          | Tokyonight (night)                       |
| Terminal       | Toggleterm, Vim-tmux-runner              |

## Directory Structure

```
.
├── init.lua                    # Main config (1700 lines): options, keymaps, core plugins
├── lua/
│   ├── custom/plugins/         # User plugins (57 plugins)
│   │   └── init.lua
│   └── kickstart/              # Kickstart modules
│       ├── plugins/            # Optional: neo-tree, debug, gitsigns, lint, autopairs
│       └── health.lua
├── ruff/pyproject.toml         # Python linting rules (Ruff config)
├── .stylua.toml                # Lua formatter (160 char width)
└── .editorconfig               # Editor settings
```

## Key Files

| File                                 | Purpose                                |
| ------------------------------------ | -------------------------------------- |
| `init.lua`                           | Core configuration, LSP setup, keymaps |
| `lua/custom/plugins/init.lua`        | Custom plugin definitions              |
| `lua/kickstart/plugins/debug.lua`    | DAP debugging setup                    |
| `lua/kickstart/plugins/gitsigns.lua` | Git hunk keymaps                       |
| `ruff/pyproject.toml`                | Python linting rules                   |

## LSP Servers Configured

Python (pyright), Lua (lua_ls), Bash (bashls), JSON (jsonls), YAML (yamlls), Ansible, Docker, GitLab CI, Helm, SQL, Markdown

Full configuration: `init.lua:810-1006`

## Key Keymaps

Leader key: `<Space>`

| Prefix      | Purpose                    |
| ----------- | -------------------------- |
| `<leader>s` | Search (files, grep, help) |
| `<leader>h` | Git hunks                  |
| `<leader>t` | Toggle/Terminal            |
| `<leader>b` | Buffer navigation          |
| `<leader>d` | Debug/DAP                  |
| `<leader>g` | Git operations             |
| `<leader>x` | Trouble diagnostics        |

See `init.lua:181-266` for full keymap definitions.

## Essential Commands

```vim
:Lazy                    " Plugin manager UI
:Lazy sync               " Sync all plugins
:Mason                   " LSP/tool installer UI
:ConformInfo             " View formatter status
:checkhealth             " Neovim health check
:Telescope               " Fuzzy finder
:Neogit                  " Git UI
:DapContinue             " Start debugger
```

## Code Style

- **Lua**: StyLua (160 char width, 2-space indent)
- **Python**: Ruff (100 char width, isort, type checking)
- **Format on save**: Enabled via Conform.nvim

## Custom Change Markers

User modifications in init.lua marked with:

```lua
-- <CUSTOM CHANGE>
```

## Additional Documentation

When working on specific areas, consult:

| Topic                                | File                                     |
| ------------------------------------ | ---------------------------------------- |
| Architectural patterns & conventions | `.claude/docs/architectural_patterns.md` |
| LSP configuration                    | `init.lua:628-1006`                      |
| Plugin organization                  | See Lazy.nvim spec in `init.lua:268+`    |
| User additional plugins              | `lua/custom/plugins/init.lua`            |
