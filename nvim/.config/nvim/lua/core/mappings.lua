local map = vim.keymap.set
local M = {}

local auto_trigger = true
local function toggle_auto_trigger()
  require('copilot.suggestion').toggle_auto_trigger()
  auto_trigger = not auto_trigger
  print('Copilot autotrigger: ' .. tostring(auto_trigger))
end

local function add_file()
  require('harpoon.mark').add_file()
  vim.cmd('redrawtabline')
end

local function show_harpoon_menu()
  require('harpoon.ui').toggle_quick_menu()
  vim.wo.cursorline = true
end

local function fml()
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
end

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

local function close_buf()
  if #vim.api.nvim_list_wins() == 1 and string.sub(vim.api.nvim_buf_get_name(0), -10) == 'NvimTree_1' then
    vim.cmd([[ q ]])
  else
    require('plugins.local.tabufline').close_buffer()
  end
end

local function harpoon_nav()
  for i = 1, 10, 1 do
    local n = i ~= 10 and i or 0
    local str = ('<C-' .. n .. '>')
    map('n', str, function()
      require('harpoon.ui').nav_file(n)
    end, { desc = 'Mark file' })
  end
end

-- Harpoon
map('n', 'F', require('core.utils').set_cur_file_first_mark, { desc = 'Set current file as first mark' })
map('n', '<C-f>', add_file, { desc = 'Mark file' })
map('n', '<C-e>', show_harpoon_menu, { desc = 'Harpoon menu' })
harpoon_nav()

-- General
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
map('n', 'dd', black_hole, { desc = 'smart delete', nowait = true, noremap = true })
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<Leader>v', '<C-w>v', { desc = 'Vertical Split  ', nowait = true })
map('n', '<Leader>h', '<C-w>s', { desc = 'Horizontal Split  ', nowait = true })
map('n', '<Leader><Leader>', '<cmd> Lazy<CR>', { desc = 'Open Lazy  ' })
map('n', '<C-s>', '<cmd> w<CR>', { desc = 'Save file' })
map('n', '<C-c>', '<cmd> %y+<CR>', { desc = 'Copy whole file' })
map('n', '<M-S-.>', '<C-w>>', { desc = 'Increase window width', nowait = true })
map('n', '<M-S-,>', '<C-w><', { desc = 'Decrease window width', nowait = true })
map('n', '<M-j>', ':m .+1<CR>==', { desc = 'Shift line down', nowait = true, silent = true })
map('n', '<M-k>', ':m .-2<CR>==', { desc = 'Shift line up', nowait = true, silent = true })
map('v', '<', '<gv', { desc = 'Un-Indent line' })
map('v', '>', '>gv', { desc = 'Indent line' })
map('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Shift selection up', nowait = true, silent = true })
map('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Shift selection down', nowait = true, silent = true })
map('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = 'Dont copy replaced text', silent = true })
map('n', '<Leader>fml', fml, { desc = 'Fuck shit up!' })
map('n', '<Leader>i', ':Inspect<CR>', { desc = 'Inspect word under cursor', nowait = true, silent = true })
map('n', '<Leader>it', ':InspectTree<CR>', { desc = 'Show AST', nowait = true, silent = true })
map('n', '<Leader>q', ':EditQuery<CR>', { desc = 'Edit TS query', nowait = true, silent = true })
map({ 'n', 'x' }, 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
map({ 'n', 'x' }, 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
map({ 'n', 'i' }, '<M-I>', toggle_auto_trigger)

-- tabufline
map('n', 'L', require('plugins.local.tabufline').tabuflineNext)
map('n', 'H', require('plugins.local.tabufline').tabuflinePrev)
map('n', '<leader>x', close_buf, { desc = 'Close current buffer ' })

-- Nvimtree
map('n', '<C-n>', '<cmd> NvimTreeToggle<CR>')

-- Telescope
map('n', '<leader>fa', '<cmd> Telescope autocommands <CR>', { desc = 'Find autocommands 󱚟 ' })
map('n', '<leader>fb', '<cmd> Telescope buffers <CR>', { desc = 'Find buffers ﬘ ' })
map('n', '<leader>fc', '<cmd> Telescope commands <CR>', { desc = 'Find commands 󰘳 ' })
map('n', '<leader>ff', '<cmd> Telescope find_files <CR>', { desc = 'Find files  ' })
map('n', '<leader>fgc', '<cmd> Telescope git_commits <CR>', { desc = 'Find commits  ' })
map('n', '<leader>fgs', '<cmd> Telescope git_status <CR>', { desc = 'Find Git status 󱖫 ' })
map('n', '<leader>fh', '<cmd> Telescope help_tags <CR>', { desc = 'Find help 󰋖' })
map('n', '<leader>fk', '<cmd> Telescope keymaps <CR>', { desc = 'Find keymaps  ' })
map('n', '<leader>fl', '<cmd> Telescope highlights <CR>', { desc = 'Find highlight groups 󰸱 ' })
map('n', '<leader>fm', '<cmd> Telescope marks <CR>', { desc = 'Find bookmarks  ' })
map('n', '<leader>fo', '<cmd> Telescope oldfiles <CR>', { desc = 'Find oldfiles  ' })
map('n', '<leader>fr', '<cmd> Telescope resume <CR>', { desc = 'Find oldfiles  ' })
map('n', '<leader>fs', '<cmd> Telescope themes <CR>', { desc = 'Find scheme  ' })
map('n', '<leader>fw', '<cmd> Telescope live_grep <CR>', { desc = 'Find word (cwd)  ' })
map('n', '<leader>fz', '<cmd> Telescope current_buffer_fuzzy_find <CR>', { desc = 'Find in current buffer  ' })

-- Terminal
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'NTerminal mode' })
map('t', '<C-h>', [[<cmd> wincmd h<CR>]], { desc = 'Move focus left' })
map('t', '<C-j>', [[<cmd> wincmd j<CR>]], { desc = 'Move focus down' })
map('t', '<C-k>', [[<cmd> wincmd k<CR>]], { desc = 'Move focus up' })
map('t', '<C-l>', [[<cmd> wincmd l<CR>]], { desc = 'Move focus right' })
map({ 'n', 't' }, '<A-v>', require('plugins.local.term').toggle_vertical, { desc = 'New vertical term' })
map({ 'n', 't' }, '<A-h>', require('plugins.local.term').toggle_horizontal, { desc = 'New horizontal term' })
map({ 'n', 't' }, '<A-f>', require('plugins.local.term').toggle_floating, { desc = 'Toggleable Floating term' })

-- one small step
map('n', '<Leader>dl', function()
  require('osv').launch({ port = 8086 })
end, { desc = ' Launch Lua adapter' })

-- trouble
map('n', '<Leader>td', function()
  require('trouble').toggle('workspace_diagnostics')
end, { desc = 'Trouble toggle workspace diagnostics  ' })

return M
