local default_plugins = {

  -- https://github.com/nvim-lua/plenary.nvim
  'nvim-lua/plenary.nvim',

  {
    -- https://github.com/folke/noice.nvim
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      -- 'rcarriga/nvim-notify',
    },
    config = function()
      require('plugins.configs.noice')
    end,
  },

  {
    -- https://github.com/kdheepak/lazygit.nvim
    'kdheepak/lazygit.nvim',
    keys = { '<leader>gg' },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_custom_config_file_path = 0
      vim.keymap.set('n', '<leader>gg', '<cmd> LazyGit<CR>', { noremap = true, silent = true })
    end,
  },

  {
    -- https://github.com/akinsho/toggleterm.nvim
    'akinsho/toggleterm.nvim',
    lazy = false,
    opts = function()
      return require('plugins.configs.toggleterm').options
    end,
    config = function(opts)
      require('plugins.configs.toggleterm').config()
      require('toggleterm').setup(opts)
    end,
  },

  {
    -- https://github.com/zbirenbaum/copilot.lua
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },

  {
    'zbirenbaum/copilot-cmp',
    event = { 'InsertEnter', 'LspAttach' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },

  {
    -- https://github.com/NvChad/base46
    'NvChad/base46',
    branch = 'v3.0',
    build = function()
      require('base46').load_all_highlights()
    end,
  },

  {
    -- https://github.com/NvChad/ui
    'NvChad/ui',
    branch = 'v3.0',
    lazy = false,
    config = function()
      require('nvchad')
    end,
  },

  {
    -- https://github.com/NvChad/nvim-colorizer.lua
    'NvChad/nvim-colorizer.lua',
    init = function()
      require('core.utils').lazy_load('nvim-colorizer.lua')
    end,
    config = function(_, opts)
      require('colorizer').setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require('colorizer').attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    -- https://github.com/williamboman/mason.nvim
    'williamboman/mason.nvim',
    dependencies = {
      -- https://github.com/williamboman/mason-lspconfig.nvim
      'williamboman/mason-lspconfig.nvim',
    },
  },

  {
    -- https://github.com/nvim-tree/nvim-web-devicons
    'nvim-tree/nvim-web-devicons',
    opts = function()
      return { override = require('nvchad.icons.devicons') }
    end,
    config = function(_, opts)
      local devicon = require('nvim-web-devicons')
      dofile(vim.g.base46_cache .. 'devicons')
      devicon.setup(opts)
      require('plugins.configs.devicon')
    end,
  },

  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    'nvim-treesitter/nvim-treesitter',
    init = function()
      require('core.utils').lazy_load('nvim-treesitter')
    end,
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
    ft = { 'gitcommit', 'diff' },
    init = function()
      vim.api.nvim_create_autocmd({ 'BufRead' }, {
        group = vim.api.nvim_create_augroup('GitSignsLazyLoad', { clear = true }),
        callback = function()
          vim.fn.system('git -C ' .. '"' .. vim.fn.expand('%:p:h') .. '"' .. ' rev-parse')
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name('GitSignsLazyLoad')
            vim.schedule(function()
              require('lazy').load({ plugins = { 'gitsigns.nvim' } })
            end)
          end
        end,
      })
    end,
    opts = function()
      return require('plugins.configs.others').gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'git')
      require('gitsigns').setup(opts)
    end,
  },

  {
    -- https://github.com/hrsh7th/nvim-cmp
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = {
      {
        -- https://github.com/L3MON4D3/LuaSnip
        'L3MON4D3/LuaSnip',
        dependencies = 'rafamadriz/friendly-snippets',
        opts = { history = true, updateevents = 'TextChanged,TextChangedI' },
        config = function(_, opts)
          require('plugins.configs.others').luasnip(opts)
          local luasnip = require('luasnip')
          luasnip.filetype_extend('javascriptreact', { 'html' })
          luasnip.filetype_extend('typescriptreact', { 'html' })
          require('luasnip/loaders/from_vscode').lazy_load()
        end,
      },

      {
        -- https://github.com/windwp/nvim-autopairs
        'windwp/nvim-autopairs',
        opts = {
          fast_wrap = {},
          disable_filetype = { 'TelescopePrompt', 'vim' },
        },
        config = function(_, opts)
          require('nvim-autopairs').setup(opts)
          local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
      },
      {
        -- https://github.com/saadparwaiz1/cmp_luasnip
        'saadparwaiz1/cmp_luasnip',
        -- https://github.com/hrsh7th/cmp-nvim-lua
        'hrsh7th/cmp-nvim-lua',
        -- https://github.com/hrsh7th/cmp-nvim-lsp
        'hrsh7th/cmp-nvim-lsp',
        -- https://github.com/hrsh7th/cmp-buffer
        'hrsh7th/cmp-buffer',
        -- https://github.com/hrsh7th/cmp-path
        'hrsh7th/cmp-path',
      },
    },
    opts = function()
      return require('plugins.configs.cmp')
    end,
    config = function(_, opts)
      require('cmp').setup(opts)
    end,
  },

  {
    -- https://github.com/nvim-tree/nvim-tree.lua
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    event = 'UIEnter',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    init = function()
      require('core.utils').load_mappings('nvimtree')
    end,
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
    init = function()
      require('core.utils').load_mappings('telescope')
    end,
    opts = function()
      return require('plugins.configs.telescope')
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'telescope')
      local telescope = require('telescope')
      telescope.setup(opts)
      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    -- https://github.com/folke/which-key.nvim
    'folke/which-key.nvim',
    keys = { '<leader>', '<c-r>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
    init = function()
      require('core.utils').load_mappings('whichkey')
    end,
    cmd = 'WhichKey',
    config = function()
      dofile(vim.g.base46_cache .. 'whichkey')
      require('plugins.configs.whichkey')
    end,
  },

  {
    -- https://github.com/folke/zen-mode.nvim
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = require('plugins.configs.zenmode'),
  },

  {
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    event = 'VimEnter',
    dependencies = {
      'folke/neodev.nvim',
    },
    config = function()
      require('plugins.configs.lsp.servers')
    end,
  },

  {
    -- https://github.com/pmizio/typescript-tools.nvim
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      local M = require('plugins.configs.lsp.lspconfig')
      local api = require('typescript-tools.api')
      require('typescript-tools').setup({

        on_attach = M.on_attach,
        settings = {
          tsserver_plugins = {
            '@styled/typescript-styled-plugin',
          },
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            jsxAttributeCompletionStyle = 'auto',
          },
        },
        handlers = {
          ['textDocument/publishDiagnostics'] = api.filter_diagnostics({ 80001 }),
        },
      })
      vim.keymap.set('n', 'fi', '<cmd> TSToolsOrganizeImports<CR>', { desc = 'Organize imports' })
    end,
  },

  {
    -- https://github.com/mrcjkb/rustaceanvim
    'mrcjkb/rustaceanvim',
    version = '^3', -- Recommended
    ft = { 'rust' },
  },

  {
    -- https://github.com/Aasim-A/scrollEOF.nvim
    'Aasim-A/scrollEOF.nvim',
    event = 'BufRead',
    config = function()
      require('scrollEOF').setup({})
    end,
  },

  {
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VimEnter',
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
        ignore = '^$', -- ignore empty lines
      })
    end,
  },

  {
    -- https://github.com/folke/trouble.nvim
    'folke/trouble.nvim',
    keys = {
      { '<leader>tf', mode = { 'n' } },
      { '<leader>tt', mode = { 'n' } },
    },
    init = function()
      require('core.utils').load_mappings('trouble')
    end,
    opts = {},
  },

  {
    -- https://github.com/hiphish/rainbow-delimiters.nvim
    'hiphish/rainbow-delimiters.nvim',
    event = 'BufReadPost',
  },

  {
    -- https://github.com/mbbill/undotree
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
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
    lazy = false,
    branch = 'harpoon2',
    init = function()
      require('core.utils').load_mappings('harpoon')
    end,
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
        default = {},
      })
    end,
  },

  {
    -- https://github.com/windwp/nvim-ts-autotag
    'windwp/nvim-ts-autotag',
    ft = {
      'typescript',
      'javascript',
      'typescriptreact',
      'javascriptreact',
      'html',
      'svelte',
      'jsx',
      'tsx',
      'markdown',
      'mdx',
    },
    config = function()
      require('nvim-ts-autotag').setup({
        autotag = {
          enable_close_on_slash = false,
        },
      })
    end,
  },

  {
    -- https://github.com/stevearc/conform.nvim
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('conform').setup({
        quiet = true,
        formatters_by_ft = {
          lua = { 'stylua' },
          typescript = { 'prettier' },
          typescriptreact = { 'prettier' },
          javascript = { 'prettier' },
          javascriptreact = { 'prettier' },
          json = { 'pretter' },
          html = { 'prettier' },
          css = { 'prettier' },
          markdown = { 'prettier' },
          sh = { 'shfmt' },
          yaml = { 'prettier' },
        },
        format_on_save = {
          timeout_ms = 500,
          async = false,
          lsp_fallback = true,
        },
        formatters = {
          shfmt = {
            prepend_args = { '-i', '2' },
          },
        },
      })
    end,
  },

  {
    -- https://github.com/kylechui/nvim-surround
    'kylechui/nvim-surround',
    event = 'VimEnter',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  {
    -- https://github.com/iamcco/markdown-preview.nvim
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    keys = {
      { '<leader>mt', mode = { 'n' } },
      { '<leader>mp', mode = { 'n' } },
      { '<leader>ms', mode = { 'n' } },
    },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    config = function()
      vim.keymap.set('n', '<leader>mt', '<cmd> MarkdownPreviewToggle <CR>', { desc = 'Toggle Markdown Preview' })
      vim.keymap.set('n', '<leader>mp', '<cmd> MarkdownPreview <CR>', { desc = 'Preview Markdown' })
      vim.keymap.set('n', '<leader>ms', '<cmd> MarkdownPreviewStop <CR>', { desc = 'Stop Markdown Preview' })
    end,
  },

  {
    -- https://github.com/folke/todo-comments.nvim
    'folke/todo-comments.nvim',
    event = 'BufReadPre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      dofile(vim.g.base46_cache .. 'todo')
    end,
    opts = {},
  },

  {
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    'lukas-reineke/indent-blankline.nvim',
    init = function()
      require('core.utils').lazy_load('indent-blankline.nvim')
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'blankline')
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require('ibl').setup(opts)
    end,
  },

  {
    -- https://github.com/luukvbaal/statuscol.nvim
    'luukvbaal/statuscol.nvim',
    init = function()
      require('core.utils').lazy_load('statuscol.nvim')
    end,
    branch = '0.10',
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup({
        ft_ignore = { 'NvimTree', 'terminal' },
        relculright = true,
        segments = {
          {
            sign = {
              name = { 'Diagnostic' },
              maxwidth = 1,
              auto = false,
            },
          },
          {
            sign = {
              name = { 'Dap' },
              maxwidth = 1,
              auto = true,
            },
          },
          {
            sign = {
              name = { 'todo' },
              maxwidth = 1,
              auto = true,
            },
          },
          {
            text = {
              builtin.lnumfunc,
              ' ',
            },
          },
          {
            sign = {
              namespace = { 'gitsign' },
              maxwidth = 1,
              auto = true,
            },
          },
        },
      })
    end,
  },
}

local config = require('core.utils').load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require('lazy').setup(default_plugins, config.lazy_nvim)
