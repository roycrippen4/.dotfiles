local map = vim.keymap.set

local default_plugins = {

  -- https://github.com/nvim-lua/plenary.nvim
  'nvim-lua/plenary.nvim',
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      { 'theHamsta/nvim-dap-virtual-text', opts = { virt_text_pos = 'eol' } },
      { 'jbyuki/one-small-step-for-vimkind', ft = { 'lua' } },
    },
    config = function()
      local dap = require('dap')
      map('n', '<Leader>dc', dap.continue, { desc = ' Continue' })
      map('n', '<Leader>do', dap.step_into, { desc = ' Step Over' })
      map('n', '<Leader>dO', dap.step_out, { desc = ' Step out' })
      map('n', '<Leader>di', dap.step_into, { desc = ' Step into' })
      map('n', '<Leader>db', dap.toggle_breakpoint, { desc = ' Toggle breakpoint' })
      require('plugins.configs.dap')
    end,
  },

  {
    -- https://github.com/kdheepak/lazygit.nvim
    'kdheepak/lazygit.nvim',
    keys = { { '<leader>gg', '<cmd> LazyGit<CR>', mode = { 'n' } } },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_custom_config_file_path = 0
    end,
  },

  {
    -- https://github.com/NvChad/base46
    'NvChad/base46',
    commit = '15ed57cdeb7048fe3e6466d3f7573e81fd1f3e9d',
    build = function()
      require('base46').load_all_highlights()
    end,
  },

  {
    -- https://github.com/NvChad/ui
    'NvChad/ui',
    commit = 'de6bf300a2b8e5ac0e9968dda9f31a50cf9fe8a5',
    lazy = false,
    config = function()
      require('nvchad')
    end,
  },

  {
    -- https://github.com/NvChad/nvim-colorizer.lua
    'NvChad/nvim-colorizer.lua',
    lazy = false,
    config = function()
      require('colorizer').setup({
        filetypes = {
          'lua',
          'css',
          'html',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
      })

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require('colorizer').attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    -- https://github.com/nvim-tree/nvim-web-devicons
    'nvim-tree/nvim-web-devicons',
    opts = function()
      return { override = require('nvchad.icons.devicons') }
    end,
    config = function(_, opts)
      require('plugins.configs.devicon')
      dofile(vim.g.base46_cache .. 'devicons')
      require('nvim-web-devicons').setup(opts)
    end,
  },

  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    'nvim-treesitter/nvim-treesitter',
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = ':TSUpdate',
    opts = function()
      return require('plugins.configs.treesitter')
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'syntax')
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    -- https://github.com/lewis6991/gitsigns.nvim
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = function()
      return require('plugins.configs.gitsigns')
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'git')
      require('gitsigns').setup(opts)
    end,
  },

  {
    'chrisgrieser/nvim-spider',
    keys = { 'w', 'e', 'b' },
  },

  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('plugins.configs.lsp.lang.cargo')
      ---@diagnostic disable-next-line
      require('crates').setup()
    end,
  },

  {
    -- https://github.com/windwp/nvim-autopairs
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('plugins.configs.autopairs')
    end,
  },

  -- https://github.com/zbirenbaum/copilot.lua
  {
    'zbirenbaum/copilot.lua',
    lazy = false,
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-CR>',
        },
      },
    },
  },

  {
    -- https://github.com/hrsh7th/nvim-cmp
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        -- https://github.com/L3MON4D3/LuaSnip
        'L3MON4D3/LuaSnip',
        dependencies = 'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip').config.set_config({ history = true, updateevents = 'TextChanged,TextChangedI' })
          require('plugins.configs.luasnip')
        end,
      },
      {
        -- https://github.com/hrsh7th/cmp-nvim-lua
        'hrsh7th/cmp-nvim-lua',
        -- https://github.com/saadparwaiz1/cmp_luasnip
        'saadparwaiz1/cmp_luasnip',
        -- https://github.com/hrsh7th/cmp-nvim-lsp
        'hrsh7th/cmp-nvim-lsp',
        -- https://github.com/hrsh7th/cmp-path
        'hrsh7th/cmp-path',
        -- https://github.com/hrsh7th/cmp-cmdline
        'hrsh7th/cmp-cmdline',
      },
    },
    config = function()
      require('plugins.configs.cmp')
    end,
  },

  {
    -- https://github.com/nvim-tree/nvim-tree.lua
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    opts = function()
      return require('plugins.configs.nvimtree')
    end,
    config = function(_, opts)
      require('nvim-tree').setup(opts)
      dofile(vim.g.base46_cache .. 'nvimtree')
    end,
  },

  {
    -- https://github.com/nvim-telescope/telescope.nvim
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    cmd = 'Telescope',
    opts = function()
      return require('plugins.configs.telescope')
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'telescope')
      local telescope = require('telescope')
      telescope.setup(opts)
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    -- https://github.com/folke/zen-mode.nvim
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = { { '<Leader>z', ':ZenMode<CR>' } },
    opts = require('plugins.configs.zenmode'),
  },

  {
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'folke/neodev.nvim',

      -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- https://github.com/williamboman/mason.nvim
      { 'williamboman/mason.nvim', cmd = 'Mason' },
    },
    config = function()
      require('plugins.configs.lsp.servers')
    end,
  },

  {
    -- https://github.com/pmizio/typescript-tools.nvim
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'svelte' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = function()
      return require('plugins.configs.lsp.lang.typescript')
    end,
  },

  {
    -- https://github.com/mrcjkb/rustaceanvim
    'mrcjkb/rustaceanvim',
    version = '^3',
    ft = { 'rust' },
  },

  {
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    'JoosepAlviste/nvim-ts-context-commentstring',
    keys = { { 'gcc', mode = { 'n' } }, { 'gc', mode = { 'v' } } },
  },

  {
    -- https://github.com/numToStr/Comment.nvim
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'v' }, 'gcc' },
    },
    config = function()
      ---@diagnostic disable-next-line
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        ignore = '^$',
      })
    end,
  },

  {
    -- https://github.com/folke/trouble.nvim
    'folke/trouble.nvim',
    keys = { { '<leader>tf', mode = { 'n' } }, { '<leader>tt', mode = { 'n' } } },
    opts = {},
  },

  {
    -- https://github.com/hiphish/rainbow-delimiters.nvim
    'hiphish/rainbow-delimiters.nvim',
    event = 'VeryLazy',
    opts = function()
      return require('plugins.configs.rainbow_delimiters')
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'rainbowdelimiters')
      require('rainbow-delimiters.setup').setup(opts)
    end,
  },

  {
    -- https://github.com/stevearc/dressing.nvim
    'stevearc/dressing.nvim',
    lazy = false,
    config = function()
      require('plugins.configs.dressing')
    end,
  },

  {
    -- https://github.com/mbbill/undotree
    'mbbill/undotree',
    keys = {
      { '<Leader>ut', vim.cmd.UndotreeToggle, mode = { 'n' }, desc = 'Toggle UndoTree 󰕍 ' },
    },
  },

  {
    -- https://github.com/max397574/better-escape.nvim
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = function()
      require('better_escape').setup()
    end,
  },

  {
    -- https://github.com/theprimeagen/harpoon
    'theprimeagen/harpoon',
    branch = 'master',
    config = function()
      require('harpoon').setup({
        menu = {
          width = 130,
        },
      })
    end,
  },

  {
    -- https://github.com/tzachar/highlight-undo.nvim
    'tzachar/highlight-undo.nvim',
    keys = { { 'u', mode = 'n' }, { '<C-r>', mode = 'n' } },
    opts = {
      duration = 400,
    },
  },

  {
    -- https://github.com/windwp/nvim-ts-autotag
    'windwp/nvim-ts-autotag',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'html', 'svelte', 'jsx', 'tsx', 'markdown', 'mdx' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  {
    -- https://github.com/stevearc/conform.nvim
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = function()
      return require('plugins.configs.conform')
    end,
    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },

  {
    -- https://github.com/kylechui/nvim-surround
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  {
    -- https://github.com/iamcco/markdown-preview.nvim
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    keys = { { '<leader>mp', '<cmd> MarkdownPreview<CR>', mode = { 'n' } } },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  {
    -- https://github.com/folke/todo-comments.nvim
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    opts = function()
      return require('plugins.configs.todo')
    end,
    config = function(_, opts)
      require('todo-comments').setup(opts)
      dofile(vim.g.base46_cache .. 'todo')
    end,
  },

  {
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = function()
      require('plugins.configs.blankline')
    end,
  },

  {
    -- https://github.com/luukvbaal/statuscol.nvim
    'luukvbaal/statuscol.nvim',
    branch = '0.10',
    event = 'BufReadPost',
    config = function()
      require('plugins.configs.statuscol')
    end,
  },

  {
    -- https://github.com/folke/which-key.nvim
    'folke/which-key.nvim',
    keys = { '<leader>', '<c-r>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
    cmd = 'WhichKey',
    config = function()
      dofile(vim.g.base46_cache .. 'whichkey')
      require('plugins.configs.whichkey')
    end,
  },

  {
    -- https://github.com/Eandrju/cellular-automaton.nvim
    'Eandrju/cellular-automaton.nvim',
    event = 'VeryLazy',
  },
}

local config = require('core.utils').load_config()

if #config.plugins ~= 0 then
  table.insert(default_plugins({ import = config.plugins }))
end

require('lazy').setup(default_plugins, config.lazy_nvim)
