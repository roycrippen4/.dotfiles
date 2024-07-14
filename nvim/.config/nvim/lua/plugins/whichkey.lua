return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  tag = 'v2.1.0',
  opts = {},
  config = function()
    -- whichkey.add({
    --   --stylua: ignore start
    --   { '<leader>d',  group = '[D]ebug',    icon = { icon = '', color = 'green' } },
    --   { '<leader>f',  group = '[F]ind',     icon = '' },
    --   { '<leader>l',  group = '[L]SP',      icon = '' },
    --   { '<leader>fg', group = '[G]it',      icon = '' },
    --   { '<leader>p',  group = 'Package',    icon = '' },
    --   { '<leader>t',  group = 'Trouble',    icon = '' },
    --   --stylua: ignore end
    -- })

    require('which-key').register({
      --stylua: ignore start
      ['<leader>d']  = { name = '  Debug'    },
      ['<leader>f']  = { name = '  Find'     },
      ['<leader>l']  = { name = '  LSP'      },
      ['<leader>fg'] = { name = '  Git'      },
      ['<leader>m']  = { name = '  Markdown' },
      ['<leader>p']  = { name = '  Package'  },
      ['<leader>t']  = { name = '  Trouble'  },
      ['<leader>u']  = { name = '  Undo'     },
      --stylua: ignore end
    })
  end,
}
