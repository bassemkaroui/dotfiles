# Architectural Patterns

## Plugin Organization Pattern (Lazy.nvim)

Plugins follow the lazy.nvim spec format with consistent structure:

```lua
return {
  {
    'owner/plugin-name',
    dependencies = { 'dep/plugin' },
    event = 'VimEnter',           -- lazy-load trigger
    cmd = { 'CommandName' },      -- or command-based loading
    keys = { { '<leader>x', fn } },
    opts = { option = value },    -- passed to setup()
    config = function()           -- custom initialization
      require('plugin').setup({})
    end,
  },
}
```

**Examples:**

- `init.lua:1043-1121` - none-ls configuration with formatters/linters
- `lua/custom/plugins/init.lua:1-50` - toggleterm with opts pattern
- `lua/custom/plugins/init.lua:165-220` - harpoon v2 with complex config

**Pattern Location:** `init.lua:181-266` (core keymaps), `init.lua:657-759` (LSP keymaps)

## LSP Configuration Pattern

1. **Server table definition** (`init.lua:810-1006`):

    ```lua
    local servers = {
      pyright = {},
      lua_ls = {
        settings = { Lua = { completion = { callSnippet = 'Replace' } } }
      },
    }
    ```

2. **Capability extension** (`init.lua:794-799`):

    - Base capabilities from `vim.lsp.protocol`
    - Extended with blink.cmp completions
    - Folding range support added

3. **Single LspAttach autocommand** (`init.lua:657-759`):
    - All buffer-local keymaps set here
    - Document highlight on CursorHold
    - Inlay hints toggle support

## Formatting Pipeline

Three-layer approach:

1. **Conform.nvim** (primary): `init.lua:1230-1270`

    - Per-filetype formatter mapping
    - Format on save via BufWritePre

2. **None-LS** (supplementary): `init.lua:1043-1121`

    - Additional formatters/linters
    - Schema-aware YAML formatting

3. **LSP fallback**: When conform has no formatter configured

## Custom Change Markers

User modifications marked with comment pattern:

```lua
-- <CUSTOM CHANGE>
-- --<CUSTOM CHANGE>
```

Locations: Throughout `init.lua`, search for `CUSTOM CHANGE`

## Plugin Loading Strategies

| Strategy                | Use Case           | Example                   |
| ----------------------- | ------------------ | ------------------------- |
| `event = "VeryLazy"`    | Non-critical UI    | lualine, trouble          |
| `event = "VimEnter"`    | Startup visibility | dashboard                 |
| `event = "BufReadPost"` | File-dependent     | treesitter                |
| `event = "InsertEnter"` | Editing features   | autopairs                 |
| `cmd = {...}`           | Command-only       | `:Neogit`, `:DapContinue` |
| `keys = {...}`          | Keymap-triggered   | harpoon, flash            |
| `ft = {...}`            | Filetype-specific  | markdown-preview          |

## Diagnostic Display Pattern

Configuration at `init.lua:763-788`:

- Severity-sorted (highest first)
- Virtual text for ERROR/WARN only
- Rounded float borders
- Nerd Font icons (signs)

## Two-File Plugin Architecture

- **`init.lua`**: Core plugins (treesitter, telescope, lsp, completion)
- **`lua/custom/plugins/init.lua`**: User additions (57 plugins)
- **`lua/kickstart/plugins/`**: Optional kickstart modules (neo-tree, debug, gitsigns)

## REPL/Terminal Pattern

Multiple terminal integrations:

- `toggleterm.nvim`: Floating terminal (`<A-t>`)
- `vim-tmux-runner`: Send to tmux panes
- `iron.nvim`: Language REPL (IPython)

Pattern: `lua/custom/plugins/init.lua:1-30` (toggleterm), `lua/custom/plugins/init.lua:500-550` (iron)

## Mason + LSPConfig Integration Pattern

**Definition:** Language servers declared in a `servers` table, auto-installed via Mason, configured via `nvim-lspconfig`.

**Rationale:** Centralizes server configuration; enables automatic installation; separates server list from setup logic.

**Examples:**

- `init.lua:810-1005` - Server definitions table with per-server settings
- `init.lua:1010-1050` - Mason-lspconfig setup handler iterates server table
