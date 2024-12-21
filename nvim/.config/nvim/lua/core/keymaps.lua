local map = vim.keymap.set
local tabline = require('local.tabufline')
local wk = require('which-key')

wk.add({
  {
    mode = 'n',
    -- stylua: ignore start
    { '<leader>it',       '<cmd> InspectTree <cr>',                desc = '[I]nspect AST',     icon = '' },
    { '<leader>q',        '<cmd> EditQuery   <cr>',                desc = 'Edit TS query',     icon = '󱄶' },
    { '<leader>m',        '<cmd> Mason       <cr>',                desc = '[M]ason',           icon = '' },
    { '<leader><Leader>', '<cmd> Lazy        <cr>',                desc = 'Open Lazy',         icon = '' },
    { '<leader>v',        '<C-w>v',                                desc = 'Vertical Split',    icon = '' },
    { '<leader>h',        '<C-w>s',                                desc = 'Horizontal Split',  icon = '' },
    { '<leader>lf',       vim.diagnostic.open_float,               desc = '[L]SP Show Errors', icon = '' },
    { '<leader>x',        require('local.tabufline').close_buffer, desc = 'Close Buffer',      icon = '' },
    -- stylua: ignore end
  },
})

-- stylua: ignore start
map('n', ';',       ':',                         { desc = 'enter commandline'                 })
map('n', 'yil',     '^y$',                       { desc = 'yank in line'                      })
map('n', '<C-n>',   '<cmd> NvimTreeToggle <cr>', { desc = 'Open NvimTree'                     })
map('n', '<C-h>',   '<C-w><C-h>',                { desc = 'Move focus to the left window'     })
map('n', '<C-l>',   '<C-w><C-l>',                { desc = 'Move focus to the right window'    })
map('n', '<C-j>',   '<C-w><C-j>',                { desc = 'Move focus to the lower window'    })
map('n', '<C-k>',   '<C-w><C-k>',                { desc = 'Move focus to the upper window'    })
map('n', '<C-h>',   '<C-w>h',                    { desc = 'Window left'                       })
map('n', '<C-l>',   '<C-w>l',                    { desc = 'Window right'                      })
map('n', '<C-j>',   '<C-w>j',                    { desc = 'Window down'                       })
map('n', '<C-k>',   '<C-w>k',                    { desc = 'Window up'                         })
map('n', '<C-s>',   '<cmd> w <cr>',              { desc = 'Save file'                         })
map('n', '<C-c>',   '<cmd> %y+ <cr>',            { desc = 'Copy whole file'                   })
map('n', '<C-S-Y>', 'mZv_y`Z',                   { desc = 'Yank from cursor to start of line' })
map('n', '<M-S-.>', '<C-w>>',                    { desc = 'Increase window width'             })
map('n', '<M-S-,>', '<C-w><',                    { desc = 'Decrease window width'             })
map('n', '<M-j>',   ':m .+1<cr>==',              { desc = 'Shift line down'                   })
map('n', '<M-k>',   ':m .-2<cr>==',              { desc = 'Shift line up'                     })
map('n', 'L',       tabline.next,                { desc = 'Go to next tabufline buffer'       })
map('n', 'H',       tabline.prev,                { desc = 'Go to prev tabufline buffer'       })
map('n', 'dd',      U.send_to_black_hole,        { desc = 'smart delete'                      })
map('n', '<C-a>',   U.ctrl_a,                    { desc = 'Extended increment'                })
map('n', '<C-x>',   U.ctrl_x,                    { desc = 'Extended decrement'                })
-- stylua: ignore end

local cursor_moved = '<cmd>lua vim.api.nvim_exec_autocmds("CursorMoved", {})<cr>'
map({ 'i', 'c' }, '<C-h>', '<Left>' .. cursor_moved)
map({ 'i', 'c' }, '<C-l>', '<Right>' .. cursor_moved)
map('i', '<C-j>', '<Down>' .. cursor_moved)
map('i', '<C-k>', '<Up>' .. cursor_moved)
map('i', '<C-w>', '<C-o>w' .. cursor_moved)
map('i', '<C-e>', '<C-o>e' .. cursor_moved)
map('i', '<C-b>', '<C-o>b' .. cursor_moved)

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
map('t', '<C-h>', '<cmd> wincmd h<cr>', { desc = 'Move focus left' })
map('t', '<C-j>', '<cmd> wincmd j<cr>', { desc = 'Move focus down' })
map('t', '<C-k>', '<cmd> wincmd k<cr>', { desc = 'Move focus up' })
map('t', '<C-l>', '<cmd> wincmd l<cr>', { desc = 'Move focus right' })
map('t', '<Esc>', '<C-\\><C-N>', { desc = 'Enter NTerminal Mode' })

-- Command line
map('c', '(', '()<Left>', { desc = 'Insert parenthesis' })
map('c', '{', '{}<Left>', { desc = 'Insert curly braces' })
map('c', '[', '[]<Left>', { desc = 'Insert square brackets' })
map('c', "'", "''<Left>", { desc = 'Insert single quotes' })
map('c', '"', '""<Left>', { desc = 'Insert double quotes' })
map('c', '`', '``<Left>', { desc = 'Insert backticks' })
map('c', '<Esc>', '<C-c>', { desc = 'Exit command mode' })
