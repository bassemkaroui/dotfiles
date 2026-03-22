-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local function shorter_name(filename) return filename:gsub(os.getenv 'HOME', '~'):gsub('/bin/python', '') end

---@module 'lazy'
---@type LazySpec
return {
  'christoomey/vim-tmux-navigator',
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        multiline_threshold = 1, -- Maximum number of lines to show for a single context
      }
    end,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      -- 'ibhagwan/fzf-lua', -- optional
    },
    init = function()
      require('which-key').add {
        { '<leader>g', group = '[G]it' },
        { '<leader>gP', '<cmd>Neogit push<CR>', desc = 'git push' },
        { '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = 'git branch with telescope' },
        { '<leader>gc', '<cmd>Neogit commit<CR>', desc = 'git commit' },
        { '<leader>gf', '<cmd>Neogit kind=floating<CR>', desc = 'git status in floating mode' },
        { '<leader>gl', '<cmd>Neogit log<CR>', desc = 'git log' },
        { '<leader>gp', '<cmd>Neogit pull<CR>', desc = 'git pull' },
        { '<leader>gs', '<cmd>Neogit<CR>', desc = 'git status' },
      }
    end,
    config = true,
  },
  -- {
  --   'numToStr/FTerm.nvim',
  --   config = function()
  --     local map = vim.api.nvim_set_keymap
  --     local opts = { noremap = true, silent = true }
  --     require('FTerm').setup {
  --       blend = 5,
  --       dimensions = {
  --         height = 0.90,
  --         width = 0.90,
  --         x = 0.5,
  --         y = 0.5,
  --       },
  --     }
  --     vim.keymap.set('n', '<A-t>', '<CMD>lua require("FTerm").toggle()<CR>')
  --     vim.keymap.set('t', '<A-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
  --   end,
  -- },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = 20, -- float size in lines (or function)
        open_mapping = [[<A-t>]], -- your toggle key
        direction = 'float', -- float | split | tab
        float_opts = { -- only for float
          border = 'curved', -- single|double|rounded|curved|none
          winblend = 0, -- transparency
        },
        start_in_insert = true, -- auto-enter insert
        persist_size = true, -- remember last size
      }
    end,
  },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        width = 140, -- Width of the floating window
        height = 40, -- Height of the floating window
        border = { '↖', '─', '┐', '│', '┘', '─', '└', '│' }, -- Border characters of the floating window
        default_mappings = true,
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
          telescope = require('telescope.themes').get_dropdown { hide_preview = false },
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = 'wipe', -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        preview_window_title = { enable = true, position = 'left' }, -- Whether
      }
    end,
  },
  {
    'rcarriga/nvim-notify',
    -- config = function()
    --   require('notify').setup {
    --     background_colour = '#000000',
    --     enabled = false,
    --   }
    -- end,
    keys = {
      { '<leader>na', '<cmd>Telescope notify<CR>', desc = 'Show [a]ll [n]otifications' },
    },
  },
  {
    'folke/noice.nvim',
    config = function()
      vim.keymap.set('n', '<leader>nn', '<cmd>Noice dismiss<CR>', { desc = 'Clear notifications' })

      -- Function to clear the recording notification
      local function clear_recording_notification() vim.cmd 'Noice dismiss' end

      -- Autocommand to clear notification when recording stops
      vim.api.nvim_create_autocmd('RecordingLeave', {
        pattern = '*',
        callback = clear_recording_notification,
      })

      require('noice').setup {
        presets = {
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        -- add any options here
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d fewer lines' },
                { find = '%d more lines' },
              },
            },
            opts = { skip = true },
          },
          {
            view = 'notify',
            filter = { event = 'msg_showmode' }, -- This will target macro recording notifications
            opts = {
              timeout = false, -- Make the notification persistent
            },
          },
        },
      }
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  -- {
  --   'akinsho/bufferline.nvim',
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   version = '*',
  --   opts = {
  --     options = {
  --       mode = 'tabs',
  --       separator_style = 'slant',
  --     },
  --   },
  -- },
  'tpope/vim-surround',
  {
    'folke/trouble.nvim',
    -- dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Open/close trouble list' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'Open trouble quickfix list' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<CR>', desc = 'Open trouble location list' },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xb',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },

      { '<leader>xt', '<cmd>TodoTrouble<CR>', desc = 'Open todos in trouble' },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        sections = {
          -- lualine_b = { 'branch', 'diff', { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' } } },
          -- lualine_c = { { 'filename', path = 3 } },
          lualine_c = { { 'buffers', show_filename_only = false } },
          lualine_x = { 'searchcount', 'encoding', 'filetype', 'filesize' },
        },
      }
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup {}
      -- REQUIRED

      vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[A]dd buffer to harpoon list' })
      vim.keymap.set('n', '<A-h>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      -- vim.keymap.set('n', '<C-h>', function()
      --   harpoon:list():select(1)
      -- end)
      -- vim.keymap.set('n', '<C-t>', function()
      --   harpoon:list():select(2)
      -- end)
      -- vim.keymap.set('n', '<C-n>', function()
      --   harpoon:list():select(3)
      -- end)
      -- vim.keymap.set('n', '<C-s>', function()
      --   harpoon:list():select(4)
      -- end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<A-p>', function() harpoon:list():prev() end)
      vim.keymap.set('n', '<A-n>', function() harpoon:list():next() end)

      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>sp', function() toggle_telescope(harpoon:list()) end, { desc = '[S]earch in har[p]oon' })
    end,
  },
  {
    'xiyaowong/nvim-transparent',
    keys = {
      { '<leader>tT', '<cmd>TransparentToggle<CR>', desc = 'Toggle Transparent' },
    },
  },
  {
    'folke/twilight.nvim',
    keys = {
      { '<leader>tt', '<cmd>Twilight<CR>', desc = 'Toggle twilight mode' },
    },
  },
  {
    'folke/zen-mode.nvim',
    dependencies = { 'folke/twilight.nvim' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      plugins = {
        -- disable some global vim options (vim.o...)
        options = {
          enabled = true,
          ruler = true, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 3, -- turn off the statusline in zen mode
        },
        twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = true }, -- disables the tmux statusline
      },
    },
    keys = {
      { '<leader>tz', '<cmd>ZenMode<CR>', desc = 'Toggle ZenMode' },
    },
  },

  -- Database
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dotenv', lazy = true },
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 45
      vim.g.db_ui_show_help = 0 -- for help just type '?'
      vim.g.db_ui_use_nvim_notify = 1
      vim.g.db_ui_win_position = 'left'
      vim.g.db_ui_auto_execute_table_helpers = 1

      require('which-key').add {
        { '<leader>D', group = '󰆼 Db Tools' },
        { '<leader>Df', '<cmd>DBUIFindBuffer<cr>', desc = ' DB UI Find buffer' },
        { '<leader>Dl', '<cmd>DBUILastQueryInfo<cr>', desc = ' DB UI Last query infos' },
        { '<leader>Dr', '<cmd>DBUIRenameBuffer<cr>', desc = ' DB UI Rename buffer' },
        { '<leader>Du', '<cmd>DBUIToggle<cr>', desc = ' DB UI Toggle' },
      }
    end,
  },
  'kristijanhusak/vim-dadbod-completion',
  {
    'tpope/vim-dadbod',
    opt = true,
    requires = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      -- require('config.dadbod').setup()
    end,
    -- [[ info ]]
    -- For postgres you need psql :
    --    sudo nala install -y postgresql-client postgresql-client-common
    --
  },

  -- Debugger
  'nvim-neotest/nvim-nio',
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>db', '<cmd>DapToggleBreakpoint<CR>', desc = 'Toggle debug breakpoint' },
      { '<leader>dC', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition : '))<CR>", desc = 'Set Conditional breakpoint' },
      { '<leader>dc', '<cmd>DapContinue<CR>', desc = 'Dap continue' },
      { '<leader>di', '<cmd>DapStepInto<CR>', desc = 'Dap step into' },
      { '<leader>do', '<cmd>DapStepOut<CR>', desc = 'Dap step out' },
      { '<leader>dn', '<cmd>DapStepOver<CR>', desc = 'Dap step over' },
      { '<leader>dk', '<cmd>DapTerminate<CR>', desc = 'Dap kill/terminate' },
    },
    init = function()
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
      vim.keymap.set('n', '<leader>dt', "<cmd>lua require('dapui').toggle()<CR>", { desc = 'DapUI Toggle' })
      vim.keymap.set('n', '<leader>dr', "<cmd>lua require('dapui').open({reset = true})<CR>", { desc = 'Reset DapUI' })
      vim.keymap.set(
        'n',
        '<leader>df',
        "<cmd>lua require('dapui').float_element(_, {height=40, width=80, position='center', enter=true})<CR>",
        { desc = 'Open element in a floating window' }
      )
      vim.keymap.set('n', '<leader>ht', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = 'Toggle DapUI in Harpoon' })
      vim.keymap.set({ 'n', 'x' }, '<leader>de', "<CMD>lua require('dapui').eval()<CR><CMD>lua require('dapui').eval()<CR>", { desc = 'Dap Evaluate' })
      -- New keymap to evaluate a custom expression entered by the user
      vim.keymap.set('n', '<leader>dE', function()
        local expression = vim.fn.input 'Evaluate expression: '
        if expression and expression ~= '' then
          require('dapui').eval(expression)
          require('dapui').eval(expression)
        else
          print 'No expression provided.'
        end
      end, { desc = 'Dap Evaluate Custom Expression' })
    end,
    -- keys = {
    --   { '<leader>dt', ':DapUiToggle<CR>', desc = 'DapUI Toggle' },
    --   { '<leader>dr', ":lua require('dapui').open({reset = true})<CR>", desc = 'Reset DapUI' },
    --   { '<leader>ht', ":lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = 'Toggle DapUI in Harpoon' },
    -- },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function() require('nvim-dap-virtual-text').setup() end,
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
    config = function(_, opts)
      local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(path)
      require('dap-python').test_runner = 'pytest'
      vim.keymap.set('n', '<leader>dpm', "<cmd>lua require('dap-python').test_method()<CR>", { desc = 'Debug python method' })
      vim.keymap.set('n', '<leader>dpc', "<cmd>lua require('dap-python').test_class()<CR>", { desc = 'Debug python class' })
      vim.keymap.set('n', '<leader>dps', "<CMD>lua require('dap-python').debug_selection()<CR>", { desc = 'Debug python selection' })
    end,
  },
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gd', '<CMD>Gvdiffsplit!<CR>', desc = 'Gvdiffsplit' },
    },
  },
  {
    'polarmutex/git-worktree.nvim',
    version = '^2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      -- 1) Default options via vim.g
      vim.g.git_worktree = {
        change_directory_command = 'cd', -- or "tcd"
        update_on_change = true,
        update_on_change_command = 'e .', -- open root in new tree
        clearjumps_on_change = true,
        autopush = false,
        confirm_telescope_deletions = true,
      }

      -- 2) Pull in the hooks API (hyphens here!)
      local gw = require 'git-worktree'
      local Hooks = require 'git-worktree.hooks'
      local cfg = require 'git-worktree.config'
      local Job = require 'plenary.job'

      -- Fix: strip remote prefix so plugin doesn't create "local/origin/<branch>" names
      local original_create = gw.create_worktree
      gw.create_worktree = function(path, branch, upstream)
        if branch and not upstream then
          local remote_prefix, stripped = branch:match '^(%w+)/(.+)$'
          if stripped then
            local remotes = vim.fn.systemlist 'git remote'
            for _, remote in ipairs(remotes) do
              if remote == remote_prefix then
                upstream = branch
                branch = stripped
                break
              end
            end
          end
        end
        return original_create(path, branch, upstream)
      end

      local builtin = Hooks.builtins
      local neo_command = require 'neo-tree.command'
      local has_yazi, yazi = pcall(require, 'yazi')

      -- SWITCH: if the buffer exists in the new tree, reload it
      -- Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
      Hooks.register(Hooks.type.SWITCH, function(new_path, prev_path)
        -- -- 0) Change Neovim's cwd to the new worktree
        -- vim.cmd('cd ' .. vim.fn.fnameescape(new_path))

        -- 1) Neo-Tree: reveal the new cwd
        --    We close any existing Neo-Tree and then reopen it in `new_path`.
        --    If Neo-Tree isn’t installed/loaded, pcall will skip it silently.
        pcall(function()
          neo_command.execute { action = 'close' }
          neo_command.execute {
            action = 'reveal',
            dir = new_path,
            position = 'current', -- or "left", etc., depending on your layout
          }
        end)

        -- 2) Yazi: toggle off & on so it rebinds to the new buffer
        if has_yazi then
          -- close any existing yazi window (no-op if none)
          pcall(yazi.close)
          -- reopen yazi in the new working directory
          pcall(function()
            -- second arg is the directory to open in
            yazi.yazi(nil, new_path)
          end)
        end

        -- 3) Finally, update the current buffer if it exists in new tree
        builtin.update_current_buffer_on_switch(new_path, prev_path)
      end)

      -- DELETE: run the update_on_change_command (open root)
      Hooks.register(Hooks.type.DELETE, function() vim.cmd(cfg.update_on_change_command) end)

      -- CREATE: check & set `remote.origin.fetch` in the new worktree
      Hooks.register(Hooks.type.CREATE, function(path, metadata)
        Job:new({
          command = 'git',
          args = { 'config', '--get', 'remote.origin.fetch' },
          cwd = path,
          on_exit = function(job)
            local cur = table.concat(job:result(), '\n')
            if cur ~= '+refs/heads/*:refs/remotes/origin/*' then
              Job:new({
                command = 'git',
                args = {
                  'config',
                  'remote.origin.fetch',
                  '+refs/heads/*:refs/remotes/origin/*',
                },
                cwd = path,
                on_exit = function(j2)
                  if j2.code == 0 then
                    vim.notify('✔️ remote.origin.fetch configured', vim.log.levels.INFO)
                  else
                    vim.notify('❌ failed to configure fetch spec', vim.log.levels.ERROR)
                  end
                end,
              }):start()
            else
              vim.notify('remote.origin.fetch already correct', vim.log.levels.DEBUG)
            end
          end,
        }):start()
      end)

      -- 3) Telescope extension (the extension name stays underscore)
      require('telescope').load_extension 'git_worktree'

      -- 4) Keymaps
      vim.keymap.set(
        'n',
        '<Leader>gW',
        function() require('telescope').extensions.git_worktree.create_git_worktree() end,
        { desc = 'Create a new worktree and configure fetch' }
      )

      vim.keymap.set(
        'n',
        '<Leader>gw',
        function() require('telescope').extensions.git_worktree.git_worktree() end,
        { desc = 'List & switch/delete git worktrees' }
      )
    end,
  },
  -- {
  --   'ThePrimeagen/git-worktree.nvim',
  --   dependencies = {
  --     'nvim-telescope/telescope.nvim',
  --     'nvim-lua/plenary.nvim',
  --   },
  --   config = function()
  --     require('git-worktree').setup()
  --     require('telescope').load_extension 'git_worktree'
  --
  --     local Job = require 'plenary.job'
  --
  --     -- Define the custom function
  --     local function create_git_worktree_and_configure()
  --       -- Call the create_git_worktree function from the telescope extension
  --       require('telescope').extensions.git_worktree.create_git_worktree()
  --
  --       -- Function to check and configure remote.origin.fetch
  --       local function check_and_configure_fetch()
  --         -- Check the current value of remote.origin.fetch
  --         Job:new({
  --           command = 'git',
  --           args = { 'config', '--get', 'remote.origin.fetch' },
  --           on_exit = function(j, return_val)
  --             local output = table.concat(j:result(), '\n')
  --             if output ~= '+refs/heads/*:refs/remotes/origin/*' then
  --               -- Configure remote.origin.fetch if it's not set correctly
  --               Job:new({
  --                 command = 'git',
  --                 args = { 'config', 'remote.origin.fetch', '+refs/heads/*:refs/remotes/origin/*' },
  --                 on_exit = function(j, return_val)
  --                   if return_val == 0 then
  --                     print 'Successfully configured remote.origin.fetch'
  --                   else
  --                     print 'Failed to configure remote.origin.fetch'
  --                   end
  --                 end,
  --               }):start()
  --             else
  --               print 'remote.origin.fetch is already configured correctly'
  --             end
  --           end,
  --         }):start()
  --       end
  --
  --       -- Call the function to check and configure fetch
  --       check_and_configure_fetch()
  --     end
  --
  --     -- Set the keymap
  --     vim.keymap.set('n', '<Leader>gW', create_git_worktree_and_configure,
  --       { desc = 'Create a new worktree and configure fetch' })
  --     vim.keymap.set('n', '<Leader>gw', "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
  --       { desc = 'Show git worktrees' })
  --   end,
  -- },
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    -- config = function()
    --   vim.g.VM_leader = '\t'
    -- end,
  },
  -- f-strings
  -- - auto-convert strings to f-strings when typing `{}` in a string
  -- - also auto-converts f-strings back to regular strings when removing `{}`
  -- {
  --   'chrisgrieser/nvim-puppeteer',
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  -- },
  -- Docstring creation
  -- - quickly create docstrings via `<leader>a`
  {
    'danymat/neogen',
    opts = true,
    keys = {
      {
        '<leader>dg',
        function() require('neogen').generate() end,
        desc = 'Generate Docstring',
      },
    },
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python', --optional
      'nvim-telescope/telescope.nvim',
    },
    ft = 'python',
    opts = {
      search = {
        anaconda_base = {
          command = 'fd /python$ $HOME/miniforge3/bin --full-path --color never -E /proc',
          type = 'anaconda',
        },
        anaconda_envs = {
          command = 'fd /bin/python$ $HOME/miniforge3/envs --full-path --color never -E /proc -E pkgs',
          type = 'anaconda',
        },
      },
      options = { on_telescope_result_callback = shorter_name, override_notify = false },
    },
    keys = {
      { '<leader>v', '<cmd>VenvSelect<cr>' },
    },
  }, -- },
  -- {
  --   'someone-stole-my-name/yaml-companion.nvim',
  --   dependencies = {
  --     { 'neovim/nvim-lspconfig' },
  --     { 'nvim-lua/plenary.nvim' },
  --     { 'nvim-telescope/telescope.nvim' },
  --   },
  --   config = function()
  --     require('telescope').load_extension 'yaml_schema'
  --     vim.keymap.set('n', '<leader>y', '<cmd>Telescope yaml_schema<CR>', { desc = 'Select a yaml schema' })
  --   end,
  -- },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
      config = function()
        vim.opt.foldcolumn = '1' -- '0' is not bad
        vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
        vim.keymap.set('n', 'z<space>', function()
          if vim.opt.foldlevel:get() == 1 then
            vim.opt.foldlevel = 99
          else
            vim.opt.foldlevel = 1
          end
        end, { noremap = true, silent = true, desc = 'Set fold level to 1' })
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        vim.keymap.set('n', 'zK', function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then vim.lsp.buf.hover() end
        end, { desc = 'Peek fold' })

        require('ufo').setup {
          provider_selector = function(bufnr, filetype, buftype) return { 'lsp', 'indent' } end,
        }
      end,
    },
  },
  {
    'amitds1997/remote-nvim.nvim',
    -- version = '*', -- Pin to GitHub releases
    branch = 'main',
    dependencies = {
      'nvim-lua/plenary.nvim', -- For standard functions
      'MunifTanjim/nui.nvim', -- To build the plugin UI
      'nvim-telescope/telescope.nvim', -- For picking b/w different remote methods
    },
    config = function()
      vim.keymap.set('n', '<leader>rs', '<CMD>RemoteStart<CR>', { desc = 'Start a remote Neovim' })
      vim.keymap.set('n', '<leader>rS', '<CMD>RemoteStop<CR>', { desc = 'Stop a remote Neovim' })
      vim.keymap.set('n', '<leader>ri', '<CMD>RemoteInfo<CR>', { desc = 'Remote Neovim Info' })
      vim.keymap.set('n', '<leader>rl', '<CMD>RemoteLog<CR>', { desc = 'Remote Neovim Logs' })

      -- Function to prompt for an argument and execute :RemoteCleanup with that argument
      local function remote_cleanup()
        -- Prompt the user for input
        local input = vim.fn.input 'Enter the remote name: '

        -- Check if input is not empty
        if input and input ~= '' then
          -- Execute the :RemoteCleanup command with the provided argument
          vim.cmd('RemoteCleanup ' .. input)
        else
          print 'Remote name is required.'
        end
      end
      vim.keymap.set('n', '<leader>rc', remote_cleanup, { desc = 'Cleanup a remote Neovim' })

      require('remote-nvim').setup {
        ssh_config = {
          scp_binary = 'rsync',
        },
        client_callback = function(port, workspace_config)
          local session_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
          local window_name = ('Remote: %s'):format(workspace_config.host)
          local cmd = ("tmux new-window -n '%s' 'nvim --server localhost:%s --remote-ui'"):format(window_name, port)
          vim.fn.jobstart(cmd, {
            detach = true,
            on_exit = function(job_id, exit_code, event_type)
              -- This function will be called when the job exits
              print('Client', job_id, 'exited with code', exit_code, 'Event type:', event_type)
            end,
          })
        end,
      }
    end,
  },
  {
    'Vigemus/iron.nvim',
    -- keys = {
    --   { '<leader>i', '<cmd>IronRepl<cr>', desc = '󱠤 Toggle REPL' },
    --   { '<leader>I', '<cmd>IronRestart<cr>', desc = '󱠤 Restart REPL' },
    --
    --   -- these keymaps need no right-hand-side, since that is defined by the
    --   -- plugin config further below
    --   { '+', mode = { 'n', 'x' }, desc = '󱠤 Send-to-REPL Operator' },
    --   { '++', desc = '󱠤 Send Line to REPL' },
    -- },
    config = function()
      local iron = require 'iron.core'
      local view = require 'iron.view'

      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            -- sh = {
            --   -- Can be a table or a function that
            --   -- returns a table (see below)
            --   command = { 'zsh' },
            -- },
            python = {
              command = { 'ipython', '-i', '--no-autoindent', '--nosep' },
              format = require('iron.fts.common').bracketed_paste_python,
            },
          },
          -- -- `view.center` takes either one or two arguments
          -- repl_open_cmd = view.center '80%',
          repl_open_cmd = 'vertical botright 85 split',
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_line = '<leader>ia',
          visual_send = '<leader>ia',
          send_motion = '+',
          send_file = '<leader>iF',
          send_paragraph = '<leader>ip',
          -- send_until_cursor = '<space>su',
          -- send_mark = '<space>sm',
          -- mark_motion = '<space>mc',
          -- mark_visual = '<space>mc',
          -- remove_mark = '<space>md',
          -- cr = '<space>s<cr>',
          interrupt = '<leader>ii',
          exit = '<leader>ik',
          -- clear = '<leader>ic',
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
      -- iron also has a list of commands, see :h iron-commands for all available commands
      vim.keymap.set('n', '<leader>it', '<cmd>IronRepl<cr>', { desc = 'Start REPL' })
      vim.keymap.set('n', '<leader>ir', '<cmd>IronRestart<cr>', { desc = 'Restart REPL' })
      vim.keymap.set('n', '<leader>if', '<cmd>IronFocus<cr>', { desc = 'Focus REPL' })
      -- vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')

      -- -- Global function to send 'pinfo' command for the entire line to IPython REPL
      -- function _G.send_ipython_help()
      --   -- Get the entire line under the cursor
      --   local line = vim.fn.getline '.'
      --   -- Create the pinfo command without adding an extra newline
      --   local pinfo_command = line .. '?'
      --   -- Send the command to the REPL
      --   iron.send(nil, { pinfo_command })
      --   -- Manually send a newline to execute the command
      --   iron.send(nil, { '' })
      --   -- Focus on the REPL
      --   vim.cmd 'IronFocus'
      -- end

      function _G.send_ipython_help_visual()
        local selected_text = vim.fn.getreg '"' -- Get the selected text from the default register
        if selected_text then
          -- Trim the selected text
          selected_text = selected_text:gsub('^%s*(.-)%s*$', '%1') -- Remove leading and trailing whitespace
          -- Append '?' and send to REPL
          iron.send(nil, { selected_text .. '?' })
          iron.send(nil, { '' })

          -- Focus on the REPL
          vim.cmd 'IronFocus'
        end
      end

      -- vim.keymap.set('n', '<leader>ih', '<CMD>lua send_ipython_help()<CR>', { desc = 'Send line for documentation' })
      vim.keymap.set('n', '<leader>ih', '<CMD>lua send_ipython_help_visual()<CR>', { desc = 'Send selected text for documentation' })
    end,
  },
  -- {
  --   'wallpants/github-preview.nvim',
  --   cmd = { 'GithubPreviewToggle' },
  --   -- keys = { '<leader>mpt' },
  --   opts = {
  --     -- config goes here
  --   },
  --   config = function(_, opts)
  --     local gpreview = require 'github-preview'
  --     gpreview.setup(opts)
  --
  --     local fns = gpreview.fns
  --     vim.keymap.set('n', '<leader>tm', fns.toggle)
  --     -- vim.keymap.set('n', '<leader>mps', fns.single_file_toggle)
  --     -- vim.keymap.set('n', '<leader>mpd', fns.details_tags_toggle)
  --   end,
  -- },
  -- {
  --   'iamcco/markdown-preview.nvim',
  --   cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  --   ft = { 'markdown' },
  --   build = function()
  --     vim.fn['mkdp#util#install']()
  --   end,
  --   -- keys = {
  --   --   { '<leader>tm', '<CMD>MarkdownPreviewToggle<CR>', desc = 'Toggle markdown preview' },
  --   -- },
  -- },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
    ft = { 'markdown' },
    keys = {
      { '<leader>tm', '<CMD>MarkdownPreviewToggle<CR>', desc = 'Toggle markdown preview' },
    },
  },
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = { render_modes = { 'n', 'c' } },
  -- },
  {
    'christoomey/vim-tmux-runner',
    enabled = true and os.getenv 'TMUX' ~= nil,
    event = 'VeryLazy',
    keys = {
      { '<leader>tC', '<cmd>VtrClearRunner<cr>', desc = 'Clear Tmux Runner' },
      { '<leader>tF', '<cmd>VtrFocusRunner<cr>', desc = 'Focus Tmux Runner' },
      { '<leader>tR', '<cmd>VtrReorientRunner<cr>', desc = 'Reorient Tmux Runner' },
      -- { '<leader>ta', '<cmd>VtrReattachRunner<cr>', desc = 'Reattach Tmux Runner' },
      { '<leader>tc', '<cmd>VtrFlushCommand<cr>', desc = 'Flush Tmux Runner Command' },
      { '<leader>tf', '<cmd>VtrSendFile<cr>', desc = 'Send File to Tmux Runner' },
      { '<leader>tk', '<cmd>VtrKillRunner<cr>', desc = 'Kill Tmux Runner' },
      { '<leader>tl', '<cmd>VtrSendLinesToRunner<cr>', desc = 'Send Lines to Tmux Runner' },
      { '<leader>to', "<cmd>VtrOpenRunner {'orientation': 'h', 'percentage': 50}<cr>", desc = 'Open Tmux Runner' },
      { '<leader>tr', '<cmd>VtrResizeRunner<cr>', desc = 'Resize Tmux Runner' },
      { '<leader>ts', '<cmd>VtrSendCommandToRunner<cr>', desc = 'Send Command to Tmux Runner' },
    },
    config = function()
      vim.g.VtrStripLeadingWhitespace = 0
      vim.g.VtrClearEmptyLines = 0
      vim.g.VtrAppendNewline = 1
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    'LunarVim/bigfile.nvim',
    event = 'BufReadPre',
    opts = {
      filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
    },
    config = function(_, opts) require('bigfile').setup(opts) end,
  },
  -- {
  --   'kelly-lin/ranger.nvim',
  --   config = function()
  --     require('ranger-nvim').setup { replace_netrw = true }
  --     vim.api.nvim_set_keymap('n', '<leader>lr', '', {
  --       noremap = true,
  --       callback = function()
  --         require('ranger-nvim').open(true)
  --       end,
  --     })
  --   end,
  -- },
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    dependencies = {
      -- check the installation instructions at
      -- https://github.com/folke/snacks.nvim
      'folke/snacks.nvim',
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>-',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
      {
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = 'Resume the last yazi session',
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = '<f1>',
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<M-,>', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude', mode = { 'n', 'x' } },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      -- { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
    opts = {
      terminal_cmd = '~/.local/bin/claude',
      terminal = {
        provider = 'snacks',
        snacks_win_opts = {
          position = 'float',
          width = 0.9,
          height = 0.9,
          border = 'rounded',
          keys = {
            claude_hide = {
              '<M-,>',
              function(self) self:hide() end,
              mode = 't',
              desc = 'Hide Claude Code',
            },
          },
        },
      },
    },
  },
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
      'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
      local null_ls = require 'null-ls'
      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters

      -- list of formatters & linters for mason to install
      require('mason-null-ls').setup {
        ensure_installed = {
          'checkmake',
          'prettier', -- ts/js formatter
          'stylua', -- lua formatter
          -- 'eslint_d', -- ts/js linter
          'shfmt',
          'ruff',
          'mypy',
        },
        -- auto-install configured formatters & linters (with null-ls)
        automatic_installation = true,
      }

      local sources = {
        diagnostics.checkmake,
        formatting.prettier.with { filetypes = { 'html', 'yaml', 'markdown' } },
        formatting.stylua,
        formatting.shfmt.with { args = { '-i', '4' } },
        formatting.terraform_fmt,
        diagnostics.mypy,
        -- diagnostics.mypy.with {
        --   -- see issue https://github.com/nvimtools/none-ls.nvim/issues/97
        --   args = function(params)
        --     return {
        --       '--hide-error-codes',
        --       '--hide-error-context',
        --       '--no-color-output',
        --       '--show-absolute-path',
        --       '--show-column-numbers',
        --       '--show-error-codes',
        --       '--no-error-summary',
        --       '--no-pretty',
        --       params.bufname,
        --       params.temp_path,
        --       params.bufname,
        --     }
        --   end,
        -- },
        require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
        -- require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I', '--ignore', 'F401' } },
        require 'none-ls.formatting.ruff_format',
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
        sources = sources,
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function() vim.lsp.buf.format { async = false } end,
            })
          end
          vim.keymap.set('n', '<leader>f', function()
            -- you can pass async = true if you like
            vim.lsp.buf.format { async = false }
          end, { buffer = bufnr, desc = 'Format buffer' })
        end,
      }
    end,
  },
  {
    'hedengran/fga.nvim',
    build = function()
      -- Auto-install the FGA LSP server if not present
      local lsp_dir = vim.fn.expand '~/.local/share/openfga-vscode-ext'
      local lsp_server = lsp_dir .. '/server/out/server.node.js'
      if vim.fn.filereadable(lsp_server) == 0 then
        vim.notify('fga.nvim: Installing FGA LSP server...', vim.log.levels.INFO)
        local cmds = string.format(
          'git clone https://github.com/openfga/vscode-ext %s && cd %s && npm install && npm run compile',
          vim.fn.shellescape(lsp_dir),
          vim.fn.shellescape(lsp_dir)
        )
        local result = vim.fn.system(cmds)
        if vim.v.shell_error == 0 then
          vim.notify('fga.nvim: FGA LSP server installed successfully', vim.log.levels.INFO)
        else
          vim.notify('fga.nvim: Failed to install FGA LSP server:\n' .. result, vim.log.levels.ERROR)
        end
      end
    end,
    config = function()
      local lsp_server = vim.fn.expand '~/.local/share/openfga-vscode-ext/server/out/server.node.js'
      local opts = { install_treesitter_grammar = false }
      if vim.fn.filereadable(lsp_server) == 1 then opts.lsp_server = lsp_server end
      require('fga').setup(opts)
    end,
  },

  -- <CUSTOM CHANGE> otter.nvim — LSP features (completion, diagnostics) for embedded languages in mise TOML
  -- {
  --   'jmbuhr/otter.nvim',
  --   ft = { 'toml' },
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = 'toml',
  --       group = vim.api.nvim_create_augroup('EmbedToml', {}),
  --       callback = function() require('otter').activate() end,
  --     })
  --   end,
  -- },
  --
  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = { 'toml' },
        group = vim.api.nvim_create_augroup('EmbedToml', {}),
        callback = function() require('otter').activate() end,
      })
    end,
  },
}
