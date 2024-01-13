local M = {}

M.noice = {
  plugin = true,
  n = {
    ['<leader>nh'] = { '<cmd> NoiceHistory <CR>', 'View Message History' },
  },
}

M.osv = {
  plugin = true,
  n = {
    ['<leader>dl'] = {
      function()
        require('osv').launch({ port = 8086 })
      end,
      opts = { desc = 'Launch Lua adapter' },
    },
  },
}

M.harpoon = {
  plugin = true,
  n = {
    ['<C-f>'] = {
      function()
        require('harpoon'):list('relative'):append()
        vim.cmd('redrawtabline')
      end,
    },
    ['<C-e>'] = {
      function()
        local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
        require('harpoon').ui:toggle_quick_menu(require('harpoon'):list('relative'), {
          title = ' ⥚ Harpoon ⥟ ',
          title_pos = 'center',
          border = 'rounded',
          context = path,
        })
        vim.wo.cursorline = true
      end,
    },
    ['<C-1>'] = {
      function()
        require('harpoon'):list('relative'):select(1)
      end,
    },
    ['<C-2>'] = {
      function()
        require('harpoon'):list('relative'):select(2)
      end,
    },
    ['<C-3>'] = {
      function()
        require('harpoon'):list('relative'):select(3)
      end,
    },
    ['<C-4>'] = {
      function()
        require('harpoon'):list('relative'):select(4)
      end,
    },
    ['<C-5>'] = {
      function()
        require('harpoon'):list('relative'):select(5)
      end,
    },
    ['<C-6>'] = {
      function()
        require('harpoon'):list('relative'):select(6)
      end,
    },
    ['<C-7>'] = {
      function()
        require('harpoon'):list('relative'):select(7)
      end,
    },
    ['<C-8>'] = {
      function()
        require('harpoon'):list('relative'):select(8)
      end,
    },
    ['<C-9>'] = {
      function()
        require('harpoon'):list('relative'):select(9)
      end,
    },
    ['<C-0>'] = {
      function()
        require('harpoon'):list('relative'):select(0)
      end,
    },
  },
}

M.disabled = {
  n = {
    ['<leader>/'] = '',
    ['<leader>D'] = '',
    ['<leader>h'] = '',
    ['<leader>n'] = '',
    ['<leader>q'] = '',
    ['<leader>v'] = '',
  },
  t = {
    ['<esc>'] = '',
  },
}

M.zenmode = {
  plugin = true,
  n = {
    ['<Leader>z'] = { ':ZenMode<CR>', 'Zen', opts = { nowait = true } },
  },
}

M.general = {
  i = {
    -- go to  beginning and end
    ['<C-b>'] = { '<ESC>^i', 'Beginning of line' },
    ['<C-e>'] = { '<End>', 'End of line' },

    -- navigate within insert mode
    ['<C-h>'] = { '<Left>', 'Move left' },
    ['<C-l>'] = { '<Right>', 'Move right' },
    ['<C-j>'] = { '<Down>', 'Move down' },
    ['<C-k>'] = { '<Up>', 'Move up' },
    -- ['<'] = { '<><Left>', 'Autopair `<` and `>`' },
  },

  n = {
    -- probably the best keybind ever
    [';'] = { ':', 'enter command mode', opts = { nowait = true } },
    ['yil'] = { '^y$', 'yank in line', opts = { noremap = true } },

    -- record into the `q` macro register by default
    ['Q'] = { 'qq', 'instant record macro to q register', opts = { noremap = true } },

    -- send whitespace to black hole register
    ['dd'] = {
      function()
        local line_content = vim.fn.getline('.')

        if type(line_content) == 'string' and string.match(line_content, '^%s*$') then
          vim.cmd('normal! "_dd')
        else
          vim.cmd('normal! dd')
        end
      end,
      'smart delete',
      opts = { nowait = true, noremap = true },
    },

    -- window binds
    ['<C-h>'] = { '<C-w>h', 'Window left' },
    ['<C-l>'] = { '<C-w>l', 'Window right' },
    ['<C-j>'] = { '<C-w>j', 'Window down' },
    ['<C-k>'] = { '<C-w>k', 'Window up' },
    ['<Leader>v'] = { '<C-w>v', 'Vertical split  ', opts = { nowait = true } },
    ['<Leader>h'] = { '<C-w>s', 'Horizontal split  ', opts = { nowait = true } },
    ['<Leader><Leader>'] = { '<cmd> Lazy<CR>', 'Open Lazy  ' },
    ['<Leader><Leader><Leader>'] = { '<cmd> Log<CR>', 'Show Logger 󰗽 ' },

    -- save
    ['<C-s>'] = { '<cmd> w <CR>', 'Save file' },

    -- Copy all
    ['<C-c>'] = { '<cmd> %y+ <CR>', 'Copy whole file' },

    -- movement
    ['j'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },
    ['k'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },
    ['<M-S-.>'] = { '<C-w>>', 'Increase window width', opts = { nowait = true } },
    ['<M-S-,>'] = { '<C-w><', 'Decrease window width', opts = { nowait = true } },

    -- toggle lsp inlay hints
    ['<Leader>lh'] = {
      function()
        vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
        print('inlay hints: ' .. tostring(vim.lsp.inlay_hint.is_enabled()))
      end,
      'Toggle lsp inlay hints 󰊠 ',
    },
  },

  v = {
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },
    ['<'] = { '<gv', 'Indent line' },
    ['>'] = { '>gv', 'Indent line' },
  },

  x = {
    ['j'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },
    ['k'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ['p'] = { 'p:let @+=@0<CR>:let @"=@0<CR>', 'Dont copy replaced text', opts = { silent = true } },
  },
}

M.tabufline = {
  plugin = true,
  n = {
    -- cycle through buffers
    ['L'] = {
      function()
        require('nvchad.tabufline').tabuflineNext()
      end,
      'Goto next buffer',
    },

    ['H'] = {
      function()
        require('nvchad.tabufline').tabuflinePrev()
      end,
      'Goto prev buffer',
    },

    -- close buffer + hide terminal buffer
    ['<leader>x'] = {
      function()
        if #vim.api.nvim_list_wins() == 1 and string.sub(vim.api.nvim_buf_get_name(0), -10) == 'NvimTree_1' then
          vim.cmd([[ q ]])
        else
          require('nvchad.tabufline').close_buffer()
        end
      end,
      'Close buffer  ',
    },
  },
}

local diagnostic_status = true
local toggle_diagnostics = function()
  diagnostic_status = not diagnostic_status
  if diagnostic_status then
    vim.api.nvim_echo({ { 'Show diagnostics' } }, false, {})
    vim.diagnostic.enable()
  else
    vim.api.nvim_echo({ { 'Hide diagnostics' } }, false, {})
    vim.diagnostic.disable()
  end
end

M.lspconfig = {
  plugin = true,
  n = {
    ['gr'] = {
      function()
        require('telescope.builtin').lsp_references()
      end,
      'Goto References  ',
    },

    ['gi'] = {
      function()
        require('telescope.builtin').lsp_implementations()
      end,
      'Goto Implementation 󰡱 ',
    },

    ['gd'] = {
      function()
        require('telescope.builtin').lsp_definitions()
      end,
      'Goto Definition 󰼭 ',
    },

    ['T'] = {
      function()
        require('telescope.builtin').lsp_type_definitions()
      end,
      'Goto Type Definition  ',
    },

    ['<C-S-K>'] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      'Signature Documentation 󰷼 ',
    },

    ['<leader>lD'] = { toggle_diagnostics, 'Toggle Diagnostics 󰨚 ' },

    ['<leader>lf'] = {
      function()
        vim.diagnostic.open_float()
      end,
      'Open floating diagnostic message 󰉪 ',
    },

    ['<leader>r'] = {
      function()
        require('plugins.local_plugs.renamer').open()
      end,
      'LSP Rename 󰑕 ',
    },

    ['<leader>la'] = {
      function()
        vim.lsp.buf.code_action()
      end,
      'Code Action  ',
    },
  },
}

M.nvimtree = {
  plugin = true,
  n = {
    ['<C-n>'] = { '<cmd> NvimTreeToggle <CR>', 'Toggle nvimtree' },
  },
}

M.telescope = {
  plugin = true,
  n = {
    -- find
    ['<leader>ff'] = { '<cmd> Telescope find_files <CR>', 'Find files  ' },
    ['<leader>fa'] = { '<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>', 'Find all  ' },
    ['<leader>fw'] = { '<cmd> Telescope live_grep <CR>', 'Find word (cwd)  ' },
    ['<leader>fb'] = { '<cmd> Telescope buffers <CR>', 'Find buffers ﬘ ' },
    ['<leader>fh'] = { '<cmd> Telescope help_tags <CR>', 'Find help 󰋖' },
    ['<leader>fo'] = { '<cmd> Telescope oldfiles <CR>', 'Find oldfiles  ' },
    ['<leader>fz'] = { '<cmd> Telescope current_buffer_fuzzy_find <CR>', 'Find in current buffer  ' },
    ['<leader>fc'] = { '<cmd> Telescope git_commits <CR>', 'Find commits  ' },
    ['<leader>fg'] = { '<cmd> Telescope git_status <CR>', 'Find Git status 󱖫 ' },
    ['<leader>fs'] = { '<cmd> Telescope themes <CR>', 'Find scheme  ' },
    ['<leader>fm'] = { '<cmd> Telescope marks <CR>', 'Find bookmarks  ' },
    ['<leader>fl'] = { '<cmd> Telescope highlights <CR>', 'Find highlight groups 󰸱 ' },
    ['<leader>fk'] = { '<cmd> Telescope keymaps <CR>', 'Find keymaps  ' },
  },
}

M.whichkey = {
  plugin = true,
  n = {
    ['<leader>wK'] = {
      function()
        vim.cmd('WhichKey')
      end,
      'Which-key all keymaps  ',
    },
    ['<leader>wk'] = {
      function()
        local input = vim.fn.input('WhichKey: ')
        vim.cmd('WhichKey ' .. input)
      end,
      'Which-key query lookup  ',
    },
  },
}

M.spider = {
  plugin = true,
  n = {
    ['w'] = {
      function()
        require('spider').motion('w', {
          customPatterns = {
            patterns = { '%)', '%>' },
            overrideDefault = false,
          },
        })
      end,
    },
    ['e'] = {
      function()
        require('spider').motion('e', {
          customPatterns = {
            patterns = { '%<' },
            overrideDefault = false,
          },
        })
      end,
    },
    ['b'] = {
      function()
        require('spider').motion('b', {
          customPatterns = {
            patterns = { '%(', '%)', '%<', '%>' },
            overrideDefault = false,
          },
        })
      end,
    },
  },
  x = {
    ['w'] = {
      function()
        require('spider').motion('w', {
          customPatterns = {
            patterns = { '%)', '%>' },
            overrideDefault = false,
          },
        })
      end,
    },
    ['e'] = {
      function()
        require('spider').motion('e', {
          customPatterns = {
            patterns = { '%<' },
            overrideDefault = false,
          },
        })
      end,
    },
    ['b'] = {
      function()
        require('spider').motion('b', {
          customPatterns = {
            patterns = { '%(', '%)', '%<', '%>' },
            overrideDefault = false,
          },
        })
      end,
    },
  },
  o = {
    ['w'] = {
      function()
        require('spider').motion('w', {
          customPatterns = {
            patterns = { '%)', '%>' },
            overrideDefault = false,
          },
        })
      end,
    },
    ['e'] = {
      function()
        require('spider').motion('e', {
          customPatterns = {
            patterns = { '%<' },
            overrideDefault = false,
          },
        })
      end,
    },
    ['b'] = {
      function()
        require('spider').motion('b', {
          customPatterns = {
            patterns = { '%(', '%)', '%<', '%>' },
            overrideDefault = false,
          },
        })
      end,
    },
  },
}

M.osv = {
  plugin = true,
  n = {
    ['<leader>dl'] = {
      function()
        require('osv').launch({ port = 8086 })
      end,
      ' Launch Lua adapter',
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ['<Leader>dc'] = {
      function()
        require('dap').continue()
      end,
      ' Continue',
    },
    ['<Leader>do'] = {
      function()
        require('dap').step_over()
      end,
      ' Step Over',
    },
    ['<Leader>dO'] = {
      function()
        require('dap').step_out()
      end,
      ' Step out',
    },
    ['<Leader>di'] = {
      function()
        require('dap').step_into()
      end,
      ' Step into',
    },
    ['<leader>db'] = {
      function()
        require('dap').toggle_breakpoint()
      end,
      ' Toggle breakpoint',
    },
  },
}

M.trouble = {
  plugin = true,
  n = {
    ['<leader>td'] = {
      function()
        require('trouble').toggle('workspace_diagnostics')
      end,
      'Trouble toggle workspace diagnostics  ',
    },
  },
}

return M
