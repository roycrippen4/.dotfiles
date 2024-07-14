local map = vim.keymap.set
local utils = require('core.utils')
local term = require('local.term')
utils.create_harpoon_nav_mappings()

local function run_current_file()
  local ft = vim.bo.ft

  if ft == 'lua' then
    vim.cmd('source')
    return
  end

  if ft == 'typescript' or 'javascript' then
    local file = vim.fn.expand('%')
    term.send('bun run ' .. file, 'H')
    return
  end

  vim.notify('Unknown filetype detected! Supported filetypes: lua, typescript, javascript', vim.log.levels.ERROR)
end

-- wk.add({
--   {
--     mode = 'n',
--     -- stylua: ignore start
--     {'<leader>iw',       '<cmd> Inspect <cr>',      desc = 'Inspect word under cursor', icon = '' },
--     {'<leader>it',       '<cmd> InspectTree <cr>',  desc = 'Show AST',                  icon = '' },
--     {'<leader>q',        '<cmd> EditQuery <cr>',    desc = 'Edit TS query',             icon = '󱄶' },
--     {'<leader>M',        '<cmd> Mason <cr>',        desc = 'Show Mason',                icon = '' },
--     {'<Leader><Leader>', '<cmd> Lazy <cr>',         desc = 'Open Lazy',                 icon = '' },
--     {'<Leader>v',        '<C-w>v',                  desc = 'Vertical Split',            icon = '' },
--     {'<Leader>h',        '<C-w>s',                  desc = 'Horizontal Split',          icon = '' },
--     {'<leader>lf',       vim.diagnostic.open_float, desc = 'Show errors in float',      icon = '' },
--     {'<leader>R',        run_lua_file,               desc = 'Run lua file',             icon = '' },
--     {'<Leader>x',        utils.close_buf,           desc = 'Close Buffer',              icon = '' },
--     -- stylua: ignore end
--   },
-- })

-- stylua: ignore start
map('n', ';',                ':',                                      { desc = 'enter commandline'                 })
map('n', 'F',                utils.set_cur_file_first_mark,            { desc = 'Set current file as first mark'    })
map('n', 'L',                require('local.tabufline').tabuflineNext, { desc = 'Go to next tabufline buffer'       })
map('n', 'H',                require('local.tabufline').tabuflinePrev, { desc = 'Go to prev tabufline buffer'       })
map('n', 'dd',               utils.send_to_black_hole,                 { desc = 'smart delete'                      })
map('n', 'yil',              '^y$',                                    { desc = 'yank in line'                      })
map('n', '<C-n>',            '<cmd> NvimTreeToggle <cr>',              { desc = 'Open NvimTree'                     })
map('n', '<C-h>',            '<C-w><C-h>',                             { desc = 'Move focus to the left window'     })
map('n', '<C-l>',            '<C-w><C-l>',                             { desc = 'Move focus to the right window'    })
map('n', '<C-j>',            '<C-w><C-j>',                             { desc = 'Move focus to the lower window'    })
map('n', '<C-k>',            '<C-w><C-k>',                             { desc = 'Move focus to the upper window'    })
map('n', '<C-h>',            '<C-w>h',                                 { desc = 'Window left'                       })
map('n', '<C-l>',            '<C-w>l',                                 { desc = 'Window right'                      })
map('n', '<C-j>',            '<C-w>j',                                 { desc = 'Window down'                       })
map('n', '<C-k>',            '<C-w>k',                                 { desc = 'Window up'                         })
map('n', '<C-s>',            '<cmd> w <cr>',                           { desc = 'Save file'                         })
map('n', '<C-c>',            '<cmd> %y+ <cr>',                         { desc = 'Copy whole file'                   })
map('n', '<C-f>',            utils.harpoon_add_file,                   { desc = 'Mark file'                         })
map('n', '<C-e>',            utils.show_harpoon_menu,                  { desc = 'Harpoon menu'                      })
map('n', '<C-S-Y>',          'mZv_y`Z',                                { desc = 'Yank from cursor to start of line' })
map('n', '<M-S-.>',          '<C-w>>',                                 { desc = 'Increase window width'             })
map('n', '<M-S-,>',          '<C-w><',                                 { desc = 'Decrease window width'             })
map('n', '<M-j>',            ':m .+1<cr>==',                           { desc = 'Shift line down'                   })
map('n', '<M-k>',            ':m .-2<cr>==',                           { desc = 'Shift line up'                     })
map('n', '<leader>i',        '<cmd> Inspect <cr>',                     { desc = '  Inspect word under cursor'      })
map('n', '<leader>it',       '<cmd> InspectTree <cr>',                 { desc = '  Show AST'                       })
map('n', '<leader>q',        '<cmd> EditQuery <cr>',                   { desc = '󱄶  Edit TS query'                  })
map('n', '<leader>lf',       vim.diagnostic.open_float,                { desc = '  Show errors in float'           })
map('n', '<leader>M',        '<cmd> Mason <cr>',                       { desc = '  Show Mason'                     })
map('n', '<leader>lr',       run_current_file,                             { desc = '  Run lua file'                   })
map('n', '<Leader>v',        '<C-w>v',                                 { desc = '  Vertical Split'                 })
map('n', '<Leader>h',        '<C-w>s',                                 { desc = '  Horizontal Split'               })
map('n', '<Leader>x',        utils.close_buf,                          { desc = '  Close Buffer'                   })
map('n', '<Leader><Leader>', '<cmd> Lazy <cr>',                        { desc = '  Open Lazy'                      })
map('n', '<C-a>', utils.ctrl_a, { desc = 'Extended increment' })
map('n', '<C-x>', utils.ctrl_x, { desc = 'Extended decrement' })
-- stylua: ignore end

map({ 'i', 'c' }, '<C-h>', '<Left>')
map({ 'i', 'c' }, '<C-l>', '<Right>')
map('i', '<C-j>', '<Down>')
map('i', '<C-k>', '<Up>')
map('i', '<C-s>', '<cmd> w <cr>', { desc = 'Save file' })
map('v', '<M-j>', ":m '>+1<cr>gv=gv", { desc = 'Shift selection up', nowait = true, silent = true })
map('v', '<M-k>', ":m '<-2<cr>gv=gv", { desc = 'Shift selection down', nowait = true, silent = true })
map('i', '<M-j>', '<ESC>:m .+1<cr>==gi', { desc = 'Shift line up', nowait = true, silent = true })
map('i', '<M-k>', '<ESC>:m .-2<cr>==gi', { desc = 'Shift line up', nowait = true, silent = true })
map('i', 'jk', '<Esc>')
map('v', '<', '<gv', { desc = 'Un-Indent line' })
map('v', '>', '>gv', { desc = 'Indent line' })
map({ 'n', 'x' }, 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
map({ 'n', 'x' }, 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
map('x', 'p', 'p:let @+=@0<cr>:let @"=@0<cr>', { desc = 'Dont copy replaced text', silent = true })

-- Terminal
map('t', '<Esc>', require('core.utils').handle_lazygit_close, { desc = 'NTerminal mode' })
map('t', '<C-h>', [[<cmd> wincmd h<cr>]], { desc = 'Move focus left' })
map('t', '<C-j>', [[<cmd> wincmd j<cr>]], { desc = 'Move focus down' })
map('t', '<C-k>', [[<cmd> wincmd k<cr>]], { desc = 'Move focus up' })
map('t', '<C-l>', [[<cmd> wincmd l<cr>]], { desc = 'Move focus right' })
map({ 'n', 't' }, '<A-v>', require('local.term').toggle_vertical, { desc = 'New vertical term' })
map({ 'n', 't' }, '<A-h>', require('local.term').toggle_horizontal, { desc = 'New horizontal term' })
map({ 'n', 't' }, '<A-f>', require('local.term').toggle_floating, { desc = 'Toggleable Floating term' })

-- Command line
map('c', '(', '()<Left>', { desc = 'Insert parenthesis' })
map('c', '{', '{}<Left>', { desc = 'Insert curly braces' })
map('c', '[', '[]<Left>', { desc = 'Insert square brackets' })
map('c', "'", "''<Left>", { desc = 'Insert single quotes' })
map('c', '"', '""<Left>', { desc = 'Insert double quotes' })
map('c', '`', '``<Left>', { desc = 'Insert backticks' })
map('c', '<Esc>', '<C-c>', { desc = 'Exit command mode' })

-- package-info.nvim
map('n', '<leader>pu', function()
  require('package-info').update()
end, { desc = '󰚰  Update Package' })
