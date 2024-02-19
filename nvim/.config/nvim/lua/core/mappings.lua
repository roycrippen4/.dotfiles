local M = {}

M.terminal = {
  n = {
    -- toggle terms
    ['<A-v>'] = {
      function()
        require('plugins.local_plugs.term').toggle('V')
      end,
      'New vertical term',
    },

    ['<A-h>'] = {
      function()
        require('plugins.local_plugs.term').toggle('H')
      end,
      'New horizontal term',
    },

    ['<A-f>'] = {
      function()
        require('plugins.local_plugs.term').toggle('F')
      end,
      'Toggleable Floating term',
    },
  },

  -- toggle terms in terminal mode
  t = {
    ['<A-v>'] = {
      function()
        require('plugins.local_plugs.term').toggle('V')
      end,
      'New vertical term',
    },

    ['<A-h>'] = {
      function()
        require('plugins.local_plugs.term').toggle('H')
      end,
      'New vertical term',
    },

    ['<A-f>'] = {
      function()
        require('plugins.local_plugs.term').toggle('F')
      end,
      'Toggleable Floating term',
    },
  },
}

-- M.cmd_window = {
--   plugin = true,
--   n = {
--     [';'] = {
--       function()
--         require('cmd-window').cmdline()
--       end,
--     },
--     [':'] = {
--       function()
--         require('cmd-window').cmdline()
--       end,
--     },
--     ['/'] = {
--       function()
--         require('cmd-window').search()
--       end,
--     },
--     ['q:'] = {
--       function()
--         require('cmd-window').cmdline_window()
--       end,
--     },
--     ['q/'] = {
--       function()
--         require('cmd-window').search_window()
--       end,
--     },
--     ['q?'] = {
--       function()
--         require('cmd-window').search_window()
--       end,
--     },
--   },
-- }

M.harpoon = {
  plugin = true,
  n = {
    ['<C-f>'] = {
      function()
        require('harpoon.mark').add_file()
        vim.cmd('redrawtabline')
      end,
    },
    ['<C-e>'] = {
      function()
        require('harpoon.ui').toggle_quick_menu()
        vim.wo.cursorline = true
      end,
    },
    ['<C-1>'] = {
      function()
        require('harpoon.ui').nav_file(1)
      end,
    },
    ['<C-2>'] = {
      function()
        require('harpoon.ui').nav_file(2)
      end,
    },
    ['<C-3>'] = {
      function()
        require('harpoon.ui').nav_file(3)
      end,
    },
    ['<C-4>'] = {
      function()
        require('harpoon.ui').nav_file(4)
      end,
    },
    ['<C-5>'] = {
      function()
        require('harpoon.ui').nav_file(5)
      end,
    },
    ['<C-6>'] = {
      function()
        require('harpoon.ui').nav_file(6)
      end,
    },
    ['<C-7>'] = {
      function()
        require('harpoon.ui').nav_file(7)
      end,
    },
    ['<C-8>'] = {
      function()
        require('harpoon.ui').nav_file(8)
      end,
    },
    ['<C-9>'] = {
      function()
        require('harpoon.ui').nav_file(9)
      end,
    },
    ['<C-0>'] = {
      function()
        require('harpoon.ui').nav_file(0)
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

---@return boolean
local function is_lua_comment_or_string()
  if vim.bo.ft ~= 'lua' then
    return false
  end

  local node = vim.treesitter.get_node():type()
  return node == 'comment' or node == 'comment_content' or node == 'chunk' or node == 'string' or node == 'string_content'
end

M.general = {
  i = {
    ['<'] = {
      function()
        if is_lua_comment_or_string() then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<><Left>', true, true, true), 'n', true)
          return
        end
        return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<', true, true, true), 'n', true)
      end,
    },

    -- go to  beginning and end
    ['<C-b>'] = { '<ESC>^i', 'Beginning of line' },
    ['<C-e>'] = { '<End>', 'End of line' },

    -- navigate within insert mode
    ['<C-h>'] = { '<Left>', 'Move left' },
    ['<C-l>'] = { '<Right>', 'Move right' },
    ['<C-j>'] = { '<Down>', 'Move down' },
    ['<C-k>'] = { '<Up>', 'Move up' },

    -- Shift lines up and down
    ['<M-j>'] = { '<ESC>:m .+1<CR>==gi', 'Shift line up', opts = { nowait = true, silent = true } },
    ['<M-k>'] = { '<ESC>:m .-2<CR>==gi', 'Shift line up', opts = { nowait = true, silent = true } },
  },

  n = {
    ['<C-D-X>'] = {
      function()
        vim.cmd(':q')
      end,
      'quit vim',
      opts = { noremap = true },
    },

    ['<leader>lr'] = { '<cmd>luafile%<CR>', 'Run lua file  ' },

    -- probably the best keybind ever
    [';'] = { ':', 'enter command mode', opts = { nowait = true } },
    ['yil'] = { '^y$', 'yank in line', opts = { noremap = true } },

    -- shortcut to run :Inspect
    ['<M-i>'] = { ':Inspect<CR>', 'Inspect word under cursor', opts = { nowait = true, silent = true } },

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

    -- Shift current lines up/down
    ['<M-j>'] = { ':m .+1<CR>==', 'Shift line up', opts = { nowait = true, silent = true } },
    ['<M-k>'] = { ':m .-2<CR>==', 'Shift line up', opts = { nowait = true, silent = true } },

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

    -- Shift selection of lines up and down
    ['<M-j>'] = { ":m '>+1<CR>gv=gv", 'Shift selection up', opts = { nowait = true, silent = true } },
    ['<M-k>'] = { ":m '<-2<CR>gv=gv", 'Shift selection down', opts = { nowait = true, silent = true } },
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

    ['<leader>ld'] = { toggle_diagnostics, 'Toggle Diagnostics 󰨚 ' },

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
    ['<leader>fa'] = { '<cmd> Telescope autocommands <CR>', 'Find autocommands 󱚟 ' },
    ['<leader>fb'] = { '<cmd> Telescope buffers <CR>', 'Find buffers ﬘ ' },
    ['<leader>fc'] = { '<cmd> Telescope commands <CR>', 'Find commands 󰘳 ' },
    ['<leader>ff'] = { '<cmd> Telescope find_files <CR>', 'Find files  ' },
    ['<leader>fgc'] = { '<cmd> Telescope git_commits <CR>', 'Find commits  ' },
    ['<leader>fgs'] = { '<cmd> Telescope git_status <CR>', 'Find Git status 󱖫 ' },
    ['<leader>fh'] = { '<cmd> Telescope help_tags <CR>', 'Find help 󰋖' },
    ['<leader>fk'] = { '<cmd> Telescope keymaps <CR>', 'Find keymaps  ' },
    ['<leader>fl'] = { '<cmd> Telescope highlights <CR>', 'Find highlight groups 󰸱 ' },
    ['<leader>fm'] = { '<cmd> Telescope marks <CR>', 'Find bookmarks  ' },
    ['<leader>fo'] = { '<cmd> Telescope oldfiles <CR>', 'Find oldfiles  ' },
    ['<leader>fr'] = { '<cmd> Telescope resume <CR>', 'Find oldfiles  ' },
    ['<leader>fs'] = { '<cmd> Telescope themes <CR>', 'Find scheme  ' },
    ['<leader>fw'] = { '<cmd> Telescope live_grep <CR>', 'Find word (cwd)  ' },
    ['<leader>fz'] = { '<cmd> Telescope current_buffer_fuzzy_find <CR>', 'Find in current buffer  ' },
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

local patterns = { '%<', '%>', "%'", '%"', '%(', '%)', '%{', '%}' }

M.spider = {
  plugin = true,
  n = {
    ['w'] = {
      function()
        require('spider').motion('w', {
          customPatterns = {
            patterns = patterns,
            overrideDefault = false,
          },
        })
      end,
    },
    ['e'] = {
      function()
        require('spider').motion('e', {
          customPatterns = {
            patterns = patterns,
            overrideDefault = false,
          },
        })
      end,
    },
    ['b'] = {
      function()
        require('spider').motion('b', {
          customPatterns = {
            patterns = patterns,
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
            patterns = patterns,
            overrideDefault = false,
          },
        })
      end,
    },
    ['e'] = {
      function()
        require('spider').motion('e', {
          customPatterns = {
            patterns = patterns,
            overrideDefault = false,
          },
        })
      end,
    },
    ['b'] = {
      function()
        require('spider').motion('b', {
          customPatterns = {
            patterns = patterns,
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
            patterns = patterns,
            overrideDefault = false,
          },
        })
      end,
    },
    ['e'] = {
      function()
        require('spider').motion('e', {
          customPatterns = {
            patterns = patterns,
            overrideDefault = false,
          },
        })
      end,
    },
    ['b'] = {
      function()
        require('spider').motion('b', {
          customPatterns = {
            patterns = patterns,
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
M.colors = {
  plugin = true,
  n = {
    ['<leader>cp'] = {
      function()
        require('colors').picker()
      end,
      'Pick a color  ',
    },
    ['<leader>cd'] = {
      function()
        require('colors').darken()
      end,
      'Darken a color  ',
    },
    ['<leader>cl'] = {
      function()
        require('colors').lighten()
      end,
      'Lighten a color  ',
    },
    ['<leader>cg'] = {
      function()
        require('colors').grayscale()
      end,
      'Lighten a color  ',
    },
    ['<leader>cS'] = { '<cmd> Telescope colors select_list <CR>', 'Choose css list to search from  ' },
    ['<leader>cs'] = { '<cmd> Telescope colors default_list <CR>', 'Find color in default list   ' },
  },
}

M.cells = {
  plugin = true,
  n = {
    ['<leader>fml'] = {
      function()
        local choice = math.random(1, 3)

        if choice == 1 then
          print('scramble')
          require('cellular-automaton').start_animation('scramble')
        end

        if choice == 2 then
          print('game_of_life')
          require('cellular-automaton').start_animation('game_of_life')
        end

        if choice == 3 then
          print('make_it_rain')
          require('cellular-automaton').start_animation('make_it_rain')
        end
      end,
      'Fuck shit up!',
    },
  },
}

-- M.harpoon = {
--   plugin = true,
--   n = {
--     ['<C-f>'] = {
--       function()
--         require('harpoon'):list('relative'):append()
--         vim.cmd('redrawtabline')
--       end,
--     },
--     ['<C-e>'] = {
--       function()
--         local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
--         require('harpoon').ui:toggle_quick_menu(require('harpoon'):list('relative'), {
--           title = ' ⥚ Harpoon ⥟ ',
--           title_pos = 'center',
--           border = 'rounded',
--           context = path,
--         })
--         vim.wo.cursorline = true
--       end,
--     },
--     ['<C-1>'] = {
--       function()
--         require('harpoon'):list('relative'):select(1)
--       end,
--     },
--     ['<C-2>'] = {
--       function()
--         require('harpoon'):list('relative'):select(2)
--       end,
--     },
--     ['<C-3>'] = {
--       function()
--         require('harpoon'):list('relative'):select(3)
--       end,
--     },
--     ['<C-4>'] = {
--       function()
--         require('harpoon'):list('relative'):select(4)
--       end,
--     },
--     ['<C-5>'] = {
--       function()
--         require('harpoon'):list('relative'):select(5)
--       end,
--     },
--     ['<C-6>'] = {
--       function()
--         require('harpoon'):list('relative'):select(6)
--       end,
--     },
--     ['<C-7>'] = {
--       function()
--         require('harpoon'):list('relative'):select(7)
--       end,
--     },
--     ['<C-8>'] = {
--       function()
--         require('harpoon'):list('relative'):select(8)
--       end,
--     },
--     ['<C-9>'] = {
--       function()
--         require('harpoon'):list('relative'):select(9)
--       end,
--     },
--     ['<C-0>'] = {
--       function()
--         require('harpoon'):list('relative'):select(0)
--       end,
--     },
--   },
-- }

return M
