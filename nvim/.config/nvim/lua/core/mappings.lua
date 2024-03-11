local map = vim.keymap.set
local M = {}

local auto_trigger = true
local function toggle_auto_trigger()
  require('copilot.suggestion').toggle_auto_trigger()
  auto_trigger = not auto_trigger
  print('Copilot autotrigger: ' .. tostring(auto_trigger))
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

local function toggle_hints()
  vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
  print('inlay hints: ' .. tostring(vim.lsp.inlay_hint.is_enabled()))
end

local function close_buf()
  if #vim.api.nvim_list_wins() == 1 and string.sub(vim.api.nvim_buf_get_name(0), -10) == 'NvimTree_1' then
    vim.cmd([[ q ]])
  else
    require('plugins.local.tabufline').close_buffer()
  end
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
-- treesitter shit
map('n', '<Leader>i', ':Inspect<CR>', { desc = 'Inspect word under cursor', nowait = true, silent = true })
map('n', '<Leader>t', ':InspectTree<CR>', { desc = 'Inspect word under cursor', nowait = true, silent = true })
map('n', '<Leader>q', ':EditQuery<CR>', { desc = 'Inspect word under cursor', nowait = true, silent = true })

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

-- tabufline
map('n', 'L', require('plugins.local.tabufline').tabuflineNext)
map('n', 'H', require('plugins.local.tabufline').tabuflinePrev)
map('n', '<leader>x', close_buf)

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

-- one small step
map('n', '<Leader>dl', function()
  require('osv').launch({ port = 8086 })
end, { desc = ' Launch Lua adapter' })

-- trouble
map('n', '<Leader>td', function()
  require('trouble').toggle('workspace_diagnostics')
end, { desc = 'Trouble toggle workspace diagnostics  ' })

-- automata
map('n', '<Leader>fml', fml, { desc = 'Fuck shit up!' })

-- copiolot
map({ 'n', 'i' }, '<M-I>', toggle_auto_trigger)

return M
