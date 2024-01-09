local default_plugins = {

  -- https://github.com/nvim-lua/plenary.nvim
  'nvim-lua/plenary.nvim',

  {
    'folke/noice.nvim',
    event = 'BufReadPre',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('plugins.configs.noice')
    end,
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = { virt_text_pos = 'eol' },
      },
      {
        'mxsdev/nvim-dap-vscode-js',
        opts = {
          debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
          adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        },
      },
      {
        'microsoft/vscode-js-debug',
        build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
      },
      {
        'jbyuki/one-small-step-for-vimkind',
        keys = {
          {
            '<leader>dl',
            function()
              require('osv').launch({ port = 8086 })
            end,
            desc = 'Launch Lua adapter',
          },
        },
      },
    },
    config = function()
      require('plugins.configs.dap')
      require('core.utils').load_mappings('dap')
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
    -- https://github.com/akinsho/toggleterm.nvim
    'akinsho/toggleterm.nvim',
    keys = { '<M-h>', '<M-v>', '<M-f>' },
    init = function()
      require('core.utils').lazy_load('toggleterm.nvim')
    end,
    config = function()
      require('plugins.configs.toggleterm').config()
      require('toggleterm').setup()
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
    cmd = 'Mason',
    dependencies = {
      -- https://github.com/williamboman/mason-lspconfig.nvim
      {
        'williamboman/mason-lspconfig.nvim',
        opts = require('plugins.configs.lsp.mason-lspconfig'),
      },
    },
    opts = require('plugins.configs.lsp.mason'),
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
    -- lazy = false,
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
          vim.fn.jobstart({ 'git', '-C', vim.loop.cwd(), 'rev-parse' }, {
            on_exit = function(_, return_code)
              if return_code == 0 then
                vim.api.nvim_del_augroup_by_name('GitSignsLazyLoad')
                vim.schedule(function()
                  require('lazy').load({ plugins = {
                    'gitsigns.nvim',
                  } })
                end)
              end
            end,
          })
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
    'chrisgrieser/nvim-spider',
    keys = {
      {
        'w',
        function()
          require('spider').motion('w', {
            customPatterns = {
              patterns = {
                '%)',
                '%>',
              },
              overrideDefault = false,
            },
          })
        end,
        mode = { 'n', 'x', 'o' },
      },
      {
        'e',
        function()
          require('spider').motion('e', {
            customPatterns = {
              patterns = {
                '%<',
              },
              overrideDefault = false,
            },
          })
        end,
        mode = { 'n', 'x', 'o' },
      },
      {
        'b',
        function()
          require('spider').motion('b', {
            customPatterns = {
              patterns = {
                '%(',
                '%)',
                '%<',
                '%>',
              },
              overrideDefault = false,
            },
          })
        end,
        mode = { 'n', 'x', 'o' },
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = 'InsertEnter',
    branch = 'v0.6',
    opts = function()
      return require('plugins.configs.ult-autopair')
    end,
    config = function(_, opts)
      require('ultimate-autopair').setup(opts)
    end,
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
        opts = { history = true, updateevents = 'TextChanged,TextChangedI' },
        config = function(_, opts)
          require('plugins.configs.others').luasnip(opts)
          local luasnip = require('luasnip')
          luasnip.filetype_extend('javascriptreact', { 'html' })
          luasnip.filetype_extend('typescriptreact', { 'html' })
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
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    -- https://github.com/folke/zen-mode.nvim
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    -- event = 'VeryLazy',
    init = function()
      require('core.utils').load_mappings('zenmode')
    end,
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
    opts = function()
      return require('plugins.configs.lsp.typescript-tools')
    end,
    config = function(_, opts)
      require('typescript-tools').setup(opts)
    end,
  },

  {
    -- https://github.com/mrcjkb/rustaceanvim
    'mrcjkb/rustaceanvim',
    version = '3.11.0',
    ft = { 'rust' },
    config = function()
      vim.g.rustaceanvim = function()
        local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
        local codelldb_path = extension_path .. 'adapter/codelldb'
        local liblldb_path = extension_path .. 'lldb/lib/liblldb'

        local cfg = require('rustaceanvim.config')
        return {
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
      end
    end,
  },

  {
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    'JoosepAlviste/nvim-ts-context-commentstring',
    keys = {
      {
        'gcc',
        mode = { 'n' },
      },
      {
        'gc',
        mode = { 'v' },
      },
    },
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
    event = 'VeryLazy',
    init = function()
      require('core.utils').lazy_load('rainbow-delimiters.nvim')
    end,
    opts = function()
      return require('plugins.configs.rainbow_delimiters')
    end,
    config = function(_, opts)
      require('rainbow-delimiters.setup').setup(opts)
    end,
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
    -- name = 'harpoon',
    -- dir = '~/.dotfiles/nvim/.config/nvim/dev/harpoon/',
    -- lazy = false,
    -- https://github.com/theprimeagen/harpoon
    'theprimeagen/harpoon',
    event = 'VeryLazy',
    branch = 'harpoon2',
    init = function()
      require('core.utils').load_mappings('harpoon')
    end,
    config = function()
      require('harpoon'):setup({
        settings = {
          sync_on_ui_close = true,
          save_on_toggle = true,
        },
        relative = {},
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
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    keys = {
      { '<leader>mp', mode = { 'n' } },
    },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    config = function()
      vim.keymap.set('n', '<leader>mp', '<cmd> MarkdownPreview <CR>', { desc = 'Preview Markdown' })
    end,
  },

  {
    -- https://github.com/folke/todo-comments.nvim
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      keywords = {
        TODO = { icon = '', color = 'info' },
        DONE = {
          icon = '',
          color = 'done',
        },
      },
      colors = {
        done = {
          '#53bf00',
        },
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'todo')
      require('todo-comments').setup(opts)
    end,
  },

  {
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    init = function()
      require('core.utils').lazy_load('indent-blankline.nvim')
    end,
    config = function()
      dofile(vim.g.base46_cache .. 'blankline')
      local hooks = require('ibl.hooks')
      local highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      }
      require('ibl').setup({
        indent = { char = '▏', highlight = 'IblChar' },
        scope = {
          char = '▏',
          highlight = highlight,
          include = {
            node_type = { lua = { 'return_statement', 'table_constructor' } },
          },
        },
      })
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },

  {
    -- https://github.com/luukvbaal/statuscol.nvim
    'luukvbaal/statuscol.nvim',
    branch = '0.10',
    event = 'BufReadPost',
    init = function()
      require('core.utils').lazy_load('statuscol.nvim')
    end,
    config = function()
      require('plugins.configs.statuscol')
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
}

local config = require('core.utils').load_config()

if #config.plugins ~= 0 then
  table.insert(default_plugins({ import = config.plugins }))
end

require('lazy').setup(default_plugins, config.lazy_nvim)
