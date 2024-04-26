local default_plugins = {
  'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim

  {
    'kdheepak/lazygit.nvim', -- https://github.com/kdheepak/lazygit.nvim
    keys = { { '<leader>gg', '<cmd> LazyGit<CR>' } },
  },

  {
    'roycrippen4/base46',
    build = function()
      require('base46').load_all_highlights()
    end,
  },

  {
    'NvChad/nvim-colorizer.lua', -- https://github.com/NvChad/nvim-colorizer.lua
    event = 'BufReadPost',
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
    config = function()
      dofile(vim.g.base46_cache .. 'syntax')
      require('nvim-treesitter.configs').setup(require('plugins.configs.treesitter'))
    end,
  },

  {
    'lewis6991/gitsigns.nvim', -- https://github.com/lewis6991/gitsigns.nvim
    event = 'VeryLazy',
    config = function()
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
      suggestion = { enabled = true, auto_trigger = true, keymap = { accept = '<M-CR>' } },
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
      'luckasRanarison/tailwind-tools.nvim', -- https://github.com/luckasRanarison/tailwind-tools.nvim
      'saadparwaiz1/cmp_luasnip', -- https://github.com/saadparwaiz1/cmp_luasnip
      'hrsh7th/cmp-nvim-lsp', -- https://github.com/hrsh7th/cmp-nvim-lsp
      'hrsh7th/cmp-path', -- https://github.com/hrsh7th/cmp-path
      'hrsh7th/cmp-cmdline', -- https://github.com/hrsh7th/cmp-cmdline
    },
    config = function()
      require('plugins.configs.cmp')
    end,
  },

  {
    'nvim-tree/nvim-tree.lua', -- https://github.com/nvim-tree/nvim-tree.lua
    lazy = false,
    config = function()
      dofile(vim.g.base46_cache .. 'nvimtree')
      require('nvim-tree').setup(require('plugins.configs.nvimtree'))
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
    'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
    event = 'VimEnter',
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
    'luckasRanarison/tailwind-tools.nvim', -- https://github.com/luckasRanarison/tailwind-tools.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'svelte' },
    opts = { conceal = { enabled = true, min_length = 40 } },
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
    event = 'VimEnter',
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
    config = function()
      require('harpoon').setup({ menu = { width = 60 } })
    end,
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
    'kylechui/nvim-surround', -- https://github.com/kylechui/nvim-surround
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  {
    'iamcco/markdown-preview.nvim', -- https://github.com/iamcco/markdown-preview.nvim
    keys = { { '<leader>mp', '<cmd> MarkdownPreview<CR>', mode = { 'n' } } },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    opts = {},
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
    event = 'BufReadPost',
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
    'vuki656/package-info.nvim', -- https://github.com/vuki656/package-info.nvim
    dependencies = 'MunifTanjim/nui.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}

local config = require('plugins.configs.ui')

if #config.plugins ~= 0 then
  table.insert(default_plugins({ import = config.plugins }))
end

require('lazy').setup(default_plugins, config.lazy_nvim)
