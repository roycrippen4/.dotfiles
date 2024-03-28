local default_plugins = {
  'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim

  {
    'mfussenegger/nvim-dap', -- https://github.com/mfussenegger/nvim-dap
    dependencies = {
      'rcarriga/nvim-dap-ui', -- https://github.com/rcarriga/nvim-dap-ui
      'jbyuki/one-small-step-for-vimkind', -- https://github.com/jbyuki/one-small-step-for-vimkind
      {
        'theHamsta/nvim-dap-virtual-text', -- https://github.com/theHamsta/nvim-dap-virtual-text
        opts = { virt_text_pos = 'eol' },
      },
    },
    keys = require('plugins.configs.dap.keys'),
    config = function()
      require('plugins.configs.dap')
    end,
  },

  {
    'kdheepak/lazygit.nvim', -- https://github.com/kdheepak/lazygit.nvim
    keys = { { '<leader>gg', '<cmd> LazyGit<CR>' } },
  },

  {
    'roycrippen4/base46',
    -- dir = 'base46',
    -- dev = true,
    build = function()
      require('base46').load_all_highlights()
    end,
  },

  {
    'NvChad/nvim-colorizer.lua', -- https://github.com/NvChad/nvim-colorizer.lua
    lazy = false,
    opts = { filetypes = { 'lua', 'css', 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte' } },
  },

  {
    'nvim-tree/nvim-web-devicons', -- https://github.com/nvim-tree/nvim-web-devicons
    config = function()
      dofile(vim.g.base46_cache .. 'devicons')
      require('nvim-web-devicons').setup({ override = require('plugins.configs.devicon') })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter', -- https://github.com/nvim-treesitter/nvim-treesitter
    lazy = false,
    priority = 1000,
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = ':TSUpdate',
    config = function()
      dofile(vim.g.base46_cache .. 'syntax')
      require('nvim-treesitter.configs').setup(require('plugins.configs.treesitter'))
    end,
  },

  {
    'lewis6991/gitsigns.nvim', -- https://github.com/lewis6991/gitsigns.nvim
    event = 'VeryLazy',
    config = function()
      dofile(vim.g.base46_cache .. 'git')
      require('gitsigns').setup(require('plugins.configs.gitsigns'))
    end,
  },

  {
    'chaoren/vim-wordmotion', -- https://github.com/chaoren/vim-wordmotion
    event = 'BufRead',
  },

  {
    'saecki/crates.nvim', --https://github.com/saecki/crates.nvim
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('plugins.configs.lsp.lang.cargo')
      require('crates').setup({})
    end,
  },

  {
    'windwp/nvim-autopairs', -- https://github.com/windwp/nvim-autopairs
    event = 'InsertEnter',
    config = function()
      require('plugins.configs.autopairs')
    end,
  },

  {
    'zbirenbaum/copilot.lua', -- https://github.com/zbirenbaum/copilot.lua
    event = 'BufReadPost',
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-CR>',
        },
      },
      copilot_node_command = vim.fn.expand('$HOME') .. '/.nvm/versions/node/v21.6.2/bin/node',
    },
  },

  {
    'hrsh7th/nvim-cmp', -- https://github.com/hrsh7th/nvim-cmp
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      {
        'L3MON4D3/LuaSnip', -- https://github.com/L3MON4D3/LuaSnip
        dependencies = 'rafamadriz/friendly-snippets', -- https://github.com/rafamadriz/friendly-snippets
        config = function()
          require('luasnip').config.set_config({ history = true, updateevents = 'TextChanged,TextChangedI' })
          require('plugins.configs.luasnip')
        end,
      },
      {
        'hrsh7th/cmp-nvim-lua', -- https://github.com/hrsh7th/cmp-nvim-lua
        'saadparwaiz1/cmp_luasnip', -- https://github.com/saadparwaiz1/cmp_luasnip
        'hrsh7th/cmp-nvim-lsp', -- https://github.com/hrsh7th/cmp-nvim-lsp
        'hrsh7th/cmp-path', -- https://github.com/hrsh7th/cmp-path
        'hrsh7th/cmp-cmdline', -- https://github.com/hrsh7th/cmp-cmdline
      },
    },
    config = function()
      require('plugins.configs.cmp')
    end,
  },

  {
    'nvim-tree/nvim-tree.lua', -- https://github.com/nvim-tree/nvim-tree.lua
    lazy = false,
    priority = 1001,
    config = function()
      require('nvim-tree').setup(require('plugins.configs.nvimtree'))
      dofile(vim.g.base46_cache .. 'nvimtree')
    end,
  },

  {
    'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- https://github.com/nvim-treesitter/nvim-treesitter
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    cmd = 'Telescope',
    config = function()
      dofile(vim.g.base46_cache .. 'telescope')
      local opts = require('plugins.configs.telescope')
      require('telescope').setup(opts)
      require('core.utils').load_ext(opts)
    end,
  },

  {
    'folke/zen-mode.nvim', -- https://github.com/folke/zen-mode.nvim
    cmd = 'ZenMode',
    keys = { { '<Leader>z', ':ZenMode<CR>' } },
    opts = require('plugins.configs.zenmode'),
  },

  {
    'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
    lazy = false,
    dependencies = {
      'folke/neodev.nvim', -- https://github.com/folke/neodev.nvim
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
      { 'williamboman/mason.nvim', cmd = 'Mason' }, -- https://github.com/williamboman/mason.nvim
      'b0o/schemastore.nvim',
    },
    config = function()
      require('plugins.configs.lsp.servers')
    end,
  },

  {
    'pmizio/typescript-tools.nvim', -- https://github.com/pmizio/typescript-tools.nvim
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'svelte' },
    dependencies = {
      'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim
      'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
    },
    config = function()
      local opts = require('plugins.configs.lsp.lang.typescript')
      require('typescript-tools').setup(opts)
    end,
  },

  {
    'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
    version = '^3',
    ft = { 'rust' },
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring', -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    keys = { { 'gcc', mode = { 'n' } }, { 'gc', mode = { 'v' } } },
  },

  {
    'LunarVim/bigfile.nvim', -- https://github.com/LunarVim/bigfile.nvim
    event = 'BufRead',
    opts = {},
  },

  {
    'numToStr/Comment.nvim', -- https://github.com/numToStr/Comment.nvim
    keys = { { 'gc', mode = { 'n', 'v' }, 'gcc' } },
    config = function()
      ---@diagnostic disable-next-line
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        ignore = '^$',
      })
    end,
  },

  {
    'folke/trouble.nvim', -- https://github.com/folke/trouble.nvim
    opts = {},
  },

  {
    'hiphish/rainbow-delimiters.nvim', -- https://github.com/hiphish/rainbow-delimiters.nvim
    event = 'VimEnter',
    config = function()
      dofile(vim.g.base46_cache .. 'rainbowdelimiters')
      require('rainbow-delimiters.setup').setup(require('plugins.configs.rainbow_delimiters'))
    end,
  },

  {
    'stevearc/dressing.nvim', -- https://github.com/stevearc/dressing.nvim
    lazy = false,
    config = function()
      require('plugins.configs.dressing')
    end,
  },

  {
    'mbbill/undotree', -- https://github.com/mbbill/undotree
    keys = {
      {
        '<Leader>ut',
        function()
          require('nvim-tree.api').tree.toggle()
          vim.cmd.UndotreeToggle()
        end,
        desc = 'Toggle UndoTree 󰕍 ',
      },
    },
  },

  {
    'max397574/better-escape.nvim', -- https://github.com/max397574/better-escape.nvim
    event = 'InsertEnter',
    opts = {},
  },

  {
    'roycrippen4/harpoon',
    -- dir = 'harpoon',
    -- dev = true,
    config = function()
      require('harpoon').setup({ menu = { width = 60 } })
    end,
  },

  {
    'tzachar/highlight-undo.nvim', -- https://github.com/tzachar/highlight-undo.nvim
    keys = { { 'u', mode = 'n' }, { '<C-r>', mode = 'n' } },
    opts = { duration = 400 },
  },

  {
    -- 'windwp/nvim-ts-autotag', -- https://github.com/windwp/nvim-ts-autotag -- waiting for PR
    'roycrippen4/nvim-ts-autotag', -- https://github.com/windwp/nvim-ts-autotag
    branch = 'fix_164',
    dependencies = 'nvim-treesitter/nvim-treesitter', -- https://github.com/nvim-treesitter/nvim-treesitter
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'html', 'svelte', 'jsx', 'tsx', 'markdown', 'mdx' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  {
    'stevearc/conform.nvim', -- https://github.com/stevearc/conform.nvim
    event = 'BufWritePre',
    config = function()
      require('conform').setup(require('plugins.configs.conform'))
    end,
  },

  {
    'folke/noice.nvim', -- https://github.com/folke/noice.nvim
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    -- stylua: ignore
    keys = {
      { '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message 󰮳 ' },
      { '<leader>nh', function() require('noice').cmd('history') end, desc = 'Noice History  ' },
      { '<leader>na', function() require('noice').cmd('all') end, desc = 'Noice All  ' },
      { '<leader>nd', function() require('noice').cmd('dismiss') end, desc = 'Noice Dismiss 󰘪 ' },
      { '<C-S-N>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll forward', mode = {'i', 'n', 's'} },
      { '<C-S-P>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll backward', mode = {'i', 'n', 's'}},
    },
    config = function()
      require('noice').setup(require('plugins.configs.noice'))
    end,
  },

  {
    'kylechui/nvim-surround', -- https://github.com/kylechui/nvim-surround
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  {
    'iamcco/markdown-preview.nvim', -- https://github.com/iamcco/markdown-preview.nvim
    ft = { 'markdown' },
    keys = { { '<leader>mp', '<cmd> MarkdownPreview<CR>', mode = { 'n' } } },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  {
    'folke/todo-comments.nvim', -- https://github.com/folke/todo-comments.nvim
    event = 'VeryLazy',
    config = function()
      require('todo-comments').setup(require('plugins.configs.todo'))
      dofile(vim.g.base46_cache .. 'todo')
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim', -- https://github.com/lukas-reineke/indent-blankline.nvim
    event = 'VeryLazy',
    config = function()
      require('plugins.configs.blankline')
    end,
  },

  {
    'luukvbaal/statuscol.nvim', -- https://github.com/luukvbaal/statuscol.nvim
    lazy = false,
    priority = 1000,
    branch = '0.10',
    dependencies = {
      'kevinhwang91/nvim-ufo', -- https://github.com/kevinhwang91/nvim-ufo
      dependencies = 'kevinhwang91/promise-async', -- https://github.com/kevinhwang91/promise-async
      opts = {
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
      },
      init = function()
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      end,
    },
    config = function()
      require('plugins.configs.statuscol')
    end,
  },

  {
    'folke/which-key.nvim', -- https://github.com/folke/which-key.nvim
    keys = { '<leader>', '<c-r>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
    config = function()
      dofile(vim.g.base46_cache .. 'whichkey')
      require('plugins.configs.whichkey')
    end,
  },

  {
    'vuki656/package-info.nvim', -- https://github.com/vuki656/package-info.nvim
    filetypes = { 'package.json' },
    opts = {},
  },

  -- {
  --   'roycrippen4/colors.nvim',
  --   event = 'VeryLazy',
  --   opts = { debug = false },
  -- },
}

local config = require('plugins.configs.ui')

if #config.plugins ~= 0 then
  table.insert(default_plugins({ import = config.plugins }))
end

require('lazy').setup(default_plugins, config.lazy_nvim)
