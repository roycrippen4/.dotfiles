local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

---@type integer[]|nil
local cursor_pos

local utils = require('core.utils')

local macrohl = augroup('MacroHL', { clear = true })
-- Toggles highlight group for the statusline macro segment
autocmd('RecordingEnter', {
  group = macrohl,
  callback = function()
    utils.start_record_highlight()
  end,
})
-- Stops toggling the highlight group for the statusline macro segment
autocmd('RecordingLeave', {
  group = macrohl,
  callback = function()
    utils.stop_timer()
  end,
})

autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'help',
    'man',
    'qf',
    'query',
    'scratch',
    'spectre_panel',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
  end,
})

autocmd('BufWritePost', {
  pattern = '*',
  callback = function()
    if not vim.fn.isdirectory(vim.fn.expand('%:p')) then
      vim.cmd('mkview')
    end
  end,
})

-- Autocommand to restore the cursor position when the buffer is read
autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line('\'"') > 0 and vim.fn.line('\'"') <= vim.fn.line('$') then
      vim.cmd('normal! g`"')
    end
  end,
})

augroup('yankpost', { clear = true })
autocmd({ 'VimEnter', 'CursorMoved' }, {
  group = 'yankpost',
  pattern = '*',
  callback = function()
    cursor_pos = vim.fn.getpos('.')
  end,
})
autocmd('TextYankPost', {
  group = 'yankpost',
  pattern = '*',
  callback = function()
    if vim.v.event.operator == 'y' then
      vim.fn.setpos('.', cursor_pos)
    end
  end,
})

local vert_help = augroup('VertHelp', {})
autocmd('FileType', {
  pattern = 'help',
  group = vert_help,
  callback = function(event)
    vim.api.nvim_set_option_value('bufhidden', 'unload', { scope = 'local' })
    vim.cmd('wincmd L')
    vim.api.nvim_win_set_width(0, 100)
    vim.keymap.set('n', 'q', '<cmd>q<CR>', { buffer = event.buf, silent = true })
  end,
})

-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*/node_modules/*',
  command = 'lua vim.diagnostic.disable(0)',
})

-- Dynamically changes the highlight group of the statusline mode segment based on the current mode
autocmd('ModeChanged', {
  callback = function()
    local m = vim.api.nvim_get_mode().mode
    local m_hl = require('plugins.configs.statusline').modes[m][2]
    local hl = vim.api.nvim_get_hl(0, { name = m_hl })
    vim.api.nvim_set_hl(0, 'St_nvimtree', { fg = hl.fg, bg = hl.bg, italic = true })
    vim.api.nvim_set_hl(0, 'St_harpoon', { fg = hl.fg, bg = hl.bg, italic = true })
  end,
})

-- Remove columns from the terminal buffer
autocmd({ 'TermOpen', 'TermEnter', 'BufEnter' }, {
  pattern = { 'term://*' },
  callback = function()
    vim.wo.scrolloff = 0
    vim.wo.relativenumber = false
    vim.wo.number = false
    vim.wo.signcolumn = 'no'
    vim.wo.statuscolumn = ''
  end,
})

-- autoquit vim if only plugin windows are open
autocmd('QuitPre', {
  callback = function()
    vim.defer_fn(function()
      utils.quit_vim()
    end, 0)
  end,
})

-- highlights the yanked portion of the buffer on yank
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})

-- Turns off the cursorline
autocmd({ 'InsertLeave', 'WinEnter', 'BufEnter' }, {
  callback = function()
    vim.o.cursorline = true
    vim.api.nvim_set_hl(0, 'CursorLine', { link = 'NvimTreeCursorLine' })
  end,
})

-- Turns on the cursorline
autocmd({ 'InsertEnter', 'WinLeave' }, {
  callback = function()
    vim.o.cursorline = false
  end,
})

-- Checks to see if a .nvmrc exists and sets node version if one is found.
-- Also sets the title string for the kitty tabs
autocmd('VimEnter', {
  callback = function()
    if os.getenv('DEBUG') == '1' then
      vim.cmd('Log')
    end

    local cwd = vim.fn.getcwd()
    utils.set_titlestring(cwd)
    utils.set_node_version(cwd)
    vim.env.PATH = '~/.nvm/versions/node/v20.10.0/bin:' .. vim.env.PATH
  end,
})

autocmd('User', {
  pattern = 'NvChadThemeReload',
  callback = function()
    local theme = require('nvconfig').ui.theme
    vim.defer_fn(function()
      utils.write_kitty_theme(theme)
    end, 100)
  end,
})
