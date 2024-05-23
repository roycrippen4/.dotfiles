return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local whichkey = require('which-key')
    whichkey.setup({ icons = { group = '' } })

    whichkey.register({
      --stylua: ignore start
      ['<leader>d']  = { name = '  Debug'    },
      ['<leader>f']  = { name = '  Find'     },
      ['<leader>l']  = { name = '  LSP'      },
      ['<leader>fg'] = { name = '  Git'      },
      ['<leader>m']  = { name = '  Markdown' },
      ['<leader>p']  = { name = '  Package'  },
      ['<leader>t']  = { name = '  Trouble'  },
      ['<leader>u']  = { name = '  Undo'  },
      --stylua: ignore end
    })
  end,
}
