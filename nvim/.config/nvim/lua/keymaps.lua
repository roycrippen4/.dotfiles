local map = vim.keymap.set

local function send_to_black_hole()
  local line_content = vim.fn.line('.')
  if type(line_content) == 'string' and string.match(line_content, '^%s*$') then
    vim.cmd('normal! "_dd')
  else
    vim.cmd('normal! dd')
  end
end
map('n', '<leader>it', '<cmd> InspectTree <cr>', { desc = '[I]nspect AST' })
map('n', '<leader>q', '<cmd> EditQuery   <cr>', { desc = 'Edit TS query' })
map('n', '<leader>m', '<cmd> Mason       <cr>', { desc = '[M]ason' })
map('n', '<leader><Leader>', '<cmd> Lazy        <cr>', { desc = 'Open Lazy' })
map('n', '<leader>v', '<C-w>v', { desc = 'Vertical Split' })
map('n', '<leader>h', '<C-w>s', { desc = 'Horizontal Split' })

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
map('n', '<C-c>',   '<cmd> %y+ <cr>',            { desc = 'Copy whole file'                   })
map('n', '<C-S-Y>', 'mZv_y`Z',                   { desc = 'Yank from cursor to start of line' })
map('n', '<M-S-.>', '<C-w>>',                    { desc = 'Increase window width'             })
map('n', '<M-S-,>', '<C-w><',                    { desc = 'Decrease window width'             })
map('n', '<M-j>',   ':m .+1<cr>==',              { desc = 'Shift line down'                   })
map('n', '<M-k>',   ':m .-2<cr>==',              { desc = 'Shift line up'                     })
map('n', 'dd',      send_to_black_hole,        { desc = 'smart delete'                      })
-- stylua: ignore end

local cursor_moved = '<cmd>lua vim.api.nvim_exec_autocmds("CursorMoved", {})<cr>'
-- Need to trigger cursor moved event manually for these mappings
map({ 'i', 'c' }, '<C-h>', '<Left>' .. cursor_moved)
map({ 'i', 'c' }, '<C-l>', '<Right>' .. cursor_moved)
map('i', '<C-j>', '<Down>' .. cursor_moved)
map('i', '<C-k>', '<Up>' .. cursor_moved)
map('i', '<C-w>', '<C-o>w' .. cursor_moved)
map('i', '<C-e>', '<C-o>e' .. cursor_moved)
map('i', '<C-b>', '<C-o>b' .. cursor_moved)
map({ 'n', 'i' }, '<C-s>', '<cmd> w <cr>', { desc = 'Save file' })

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
map('c', '<Esc>', '<C-c>', { desc = 'Exit command mode' })
