local function send_to_black_hole()
  local line_content = vim.fn.line('.')
  if type(line_content) == 'string' and string.match(line_content, '^%s*$') then
    vim.cmd('normal! "_dd')
  else
    vim.cmd('normal! dd')
  end
end

vim.keymap.set('n', '<leader>it', '<cmd> InspectTree <cr>', { desc = '[I]nspect AST' })
vim.keymap.set('n', '<leader>q', '<cmd> EditQuery   <cr>', { desc = 'Edit TS query' })
vim.keymap.set('n', '<leader>m', '<cmd> Mason       <cr>', { desc = '[M]ason' })
vim.keymap.set('n', '<leader><Leader>', '<cmd> Lazy        <cr>', { desc = 'Open Lazy' })
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = 'Vertical Split' })
vim.keymap.set('n', '<leader>h', '<C-w>s', { desc = 'Horizontal Split' })

vim.keymap.set('n', '<S-cr>', 'O<esc>', { desc = 'Insert newline above current line' })
vim.keymap.set('n', '<cr>', 'o<esc>', { desc = 'Insert newline below current line' })
vim.keymap.set('n', ';', ':', { desc = 'enter commandline' })
vim.keymap.set('n', 'yil', '^y$', { desc = 'yank in line' })
vim.keymap.set('n', '<C-n>', '<cmd> NvimTreeToggle <cr>', { desc = 'Open NvimTree' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-c>', '<cmd> %y+ <cr>', { desc = 'Copy whole file' })
vim.keymap.set('n', '<C-S-Y>', 'mZv_y`Z', { desc = 'Yank from cursor to start of line' })
vim.keymap.set('n', '<M-S-.>', '<C-w>>', { desc = 'Increase window width' })
vim.keymap.set('n', '<M-S-,>', '<C-w><', { desc = 'Decrease window width' })
vim.keymap.set('n', '<M-j>', ':m .+1<cr>==', { desc = 'Shift line down' })
vim.keymap.set('n', '<M-k>', ':m .-2<cr>==', { desc = 'Shift line up' })
vim.keymap.set('n', 'dd', send_to_black_hole, { desc = 'smart delete' })
vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  return '<esc>'
end, { desc = 'Clear hlsearch', expr = true })

local cursor_moved = '<cmd>lua vim.api.nvim_exec_autocmds("CursorMoved", {})<cr>'
-- Need to trigger cursor moved event manually for these mappings
vim.keymap.set({ 'i', 'c' }, '<C-h>', '<Left>' .. cursor_moved)
vim.keymap.set({ 'i', 'c' }, '<C-l>', '<Right>' .. cursor_moved)
vim.keymap.set('i', '<C-j>', '<Down>' .. cursor_moved)
vim.keymap.set('i', '<C-k>', '<Up>' .. cursor_moved)
vim.keymap.set('i', '<C-w>', '<C-o>w' .. cursor_moved)
vim.keymap.set('i', '<C-e>', '<C-o>e' .. cursor_moved)
vim.keymap.set('i', '<C-b>', '<C-o>b' .. cursor_moved)
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd> w <cr>', { desc = 'Save file' })

vim.keymap.set('v', '<M-j>', ":m '>+1<cr>gv=gv", { desc = 'Shift selection up', nowait = true, silent = true })
vim.keymap.set('v', '<M-k>', ":m '<-2<cr>gv=gv", { desc = 'Shift selection down', nowait = true, silent = true })
vim.keymap.set('i', '<M-j>', '<ESC>:m .+1<cr>==gi', { desc = 'Shift line up', nowait = true, silent = true })
vim.keymap.set('i', '<M-k>', '<ESC>:m .-2<cr>==gi', { desc = 'Shift line up', nowait = true, silent = true })
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('v', '<', '<gv', { desc = 'Un-Indent line' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent line' })
vim.keymap.set({ 'n', 'x' }, 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
vim.keymap.set('x', 'p', 'p:let @+=@0<cr>:let @"=@0<cr>', { desc = 'Dont copy replaced text', silent = true })

-- Terminal
vim.keymap.set('t', '<C-h>', '<cmd> wincmd h<cr>', { desc = 'Move focus left' })
vim.keymap.set('t', '<C-j>', '<cmd> wincmd j<cr>', { desc = 'Move focus down' })
vim.keymap.set('t', '<C-k>', '<cmd> wincmd k<cr>', { desc = 'Move focus up' })
vim.keymap.set('t', '<C-l>', '<cmd> wincmd l<cr>', { desc = 'Move focus right' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Enter NTerminal Mode' })

-- Command line
vim.keymap.set('c', '<Esc>', '<C-c>', { desc = 'Exit command mode' })
