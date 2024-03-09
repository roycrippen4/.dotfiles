local map = vim.keymap.set
local M = {}

---@return boolean
local function is_lua_comment_or_string()
  if vim.bo.ft ~= 'lua' then
    return false
  end

  local node = vim.treesitter.get_node():type()
  return node == 'comment' or node == 'comment_content' or node == 'chunk' or node == 'string' or node == 'string_content'
end

local function black_hole()
  local line_content = vim.fn.line('.')
  if type(line_content) == 'string' and string.match(line_content, '^%s*$') then
    vim.cmd('normal! "_dd')
  else
    vim.cmd('normal! dd')
  end
end

local function handle_angle()
  if is_lua_comment_or_string() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<><Left>', true, true, true), 'n', true)
    return
  end
  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<', true, true, true), 'n', true)
end

local function toggle_hints()
  vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
  print('inlay hints: ' .. tostring(vim.lsp.inlay_hint.is_enabled()))
end

-- Terminal
map('n', '<A-v>', function()
  require('plugins.local.term').toggle('V')
end, { desc = 'New vertical term' })

map('n', '<A-h>', function()
  require('plugins.local.term').toggle('H')
end, { desc = 'New horizontal term' })

map('n', '<A-f>', function()
  require('plugins.local.term').toggle('F')
end, { desc = 'Toggleable Floating term' })

map('t', '<A-v>', function()
  require('plugins.local.term').toggle('V')
end, { desc = 'New vertical term' })

map('t', '<A-h>', function()
  require('plugins.local.term').toggle('H')
end, { desc = 'New vertical term' })

map('t', '<A-f>', function()
  require('plugins.local.term').toggle('F')
end, { desc = 'Toggleable Floating term' })

-- Harpoon
map('n', 'F', function()
  require('core.utils').set_cur_file_first_mark()
  vim.cmd('redrawtabline')
end)

map('n', '<C-f>', function()
  require('harpoon.mark').add_file()
  vim.cmd('redrawtabline')
end, { desc = 'Mark file' })

map('n', '<C-e>', function()
  require('harpoon.ui').toggle_quick_menu()
  vim.wo.cursorline = true
end)

map('n', '<C-1>', function()
  require('harpoon.ui').nav_file(1)
end, { desc = 'Mark file' })

map('n', '<C-2>', function()
  require('harpoon.ui').nav_file(2)
end, { desc = 'Mark file' })

map('n', '<C-3>', function()
  require('harpoon.ui').nav_file(3)
end, { desc = 'Mark file' })

map('n', '<C-4>', function()
  require('harpoon.ui').nav_file(4)
end, { desc = 'Mark file' })

map('n', '<C-5>', function()
  require('harpoon.ui').nav_file(5)
end, { desc = 'Mark file' })

map('n', '<C-6>', function()
  require('harpoon.ui').nav_file(6)
end, { desc = 'Mark file' })

map('n', '<C-7>', function()
  require('harpoon.ui').nav_file(7)
end, { desc = 'Mark file' })

map('n', '<C-8>', function()
  require('harpoon.ui').nav_file(8)
end, { desc = 'Mark file' })

map('n', '<C-9>', function()
  require('harpoon.ui').nav_file(9)
end, { desc = 'Mark file' })

map('n', '<C-0>', function()
  require('harpoon.ui').nav_file(0)
end, { desc = 'Mark file' })

map('i', '<', handle_angle, { desc = 'Angle brackets... sometimes...' })
map('i', '<C-h>', '<Left>', { desc = 'Move left' })
map('i', '<C-l>', '<Right>', { desc = 'Move right' })
map('i', '<C-j>', '<Down>', { desc = 'Move down' })
map('i', '<C-k>', '<Up>', { desc = 'Move up' })
map('i', '<M-j>', '<ESC>:m .+1<CR>==gi', { desc = 'Shift line up', nowait = true, silent = true })
map('i', '<M-k>', '<ESC>:m .-2<CR>==gi', { desc = 'Shift line up', nowait = true, silent = true })

map('n', '<leader>lr', '<cmd>luafile%<CR>', { desc = 'Run lua file  ' })
map('n', ';', ':', { desc = 'enter commandline', nowait = true })
map('n', 'yil', '^y$', { desc = 'yank in line', noremap = true })
map('n', '<M-i>', ':Inspect<CR>', { desc = 'Inspect word under cursor', nowait = true, silent = true })
map('n', 'dd', black_hole, { desc = 'smart delete', nowait = true, noremap = true })
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<Leader>v', '<C-w>v', { desc = 'Vertical Split  ', nowait = true })
map('n', '<Leader>h', '<C-w>h', { desc = 'Horizontal Split  ', nowait = true })
map('n', '<Leader><Leader>', '<cmd> Lazy<CR>', { desc = 'Open Lazy  ' })
map('n', '<C-s>', '<cmd> w<CR>', { desc = 'Save file' })
map('n', '<C-c>', '<cmd> %y+<CR>', { desc = 'Copy whole file' })
map('n', 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
map('n', 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
map('n', '<M-S-.>', '<C-w>>', { desc = 'Increase window width', nowait = true })
map('n', '<M-S-,>', '<C-w><', { desc = 'Decrease window width', nowait = true })
map('n', '<M-j>', ':m .+1<CR>==', { desc = 'Shift line down', nowait = true, silent = true })
map('n', '<M-k>', ':m .-2<CR>==', { desc = 'Shift line up', nowait = true, silent = true })
map('n', '<Leader>h', toggle_hints, { desc = 'Toggle lsp inlay hints 󰊠 ' })

map('v', '<', '<gv', { desc = 'Un-Indent line' })
map('v', '>', '>gv', { desc = 'Indent line' })
map('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Shift selection up', nowait = true, silent = true })
map('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Shift selection down', nowait = true, silent = true })

map('x', 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
map('x', 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
map('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = 'Dont copy replaced text', silent = true })

M.tabufline = {
  plugin = true,
  n = {
    -- cycle through buffers
    ['L'] = {
      function()
        require('plugins.local.tabufline').tabuflineNext()
      end,
      'Goto next buffer',
    },

    ['H'] = {
      function()
        require('plugins.local.tabufline').tabuflinePrev()
      end,
      'Goto prev buffer',
    },

    -- close buffer + hide terminal buffer
    ['<leader>x'] = {
      function()
        if #vim.api.nvim_list_wins() == 1 and string.sub(vim.api.nvim_buf_get_name(0), -10) == 'NvimTree_1' then
          vim.cmd([[ q ]])
        else
          require('plugins.local.tabufline').close_buffer()
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
        require('plugins.local.renamer').open()
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

return M
