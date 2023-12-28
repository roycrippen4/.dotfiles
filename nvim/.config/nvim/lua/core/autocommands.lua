local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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

-- Disable new line comments for all filetypes
autocmd('BufEnter', {
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
  desc = 'Disable New Line Comment',
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

autocmd('QuitPre', {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match('NvimTree_') ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= '' then
        table.insert(floating_wins, w)
      end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
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
autocmd({ 'VimEnter' }, {
  callback = function()
    local cwd = vim.fn.getcwd()
    utils.set_titlestring(cwd)
    utils.set_node_version(cwd)
    vim.env.PATH = '~/.nvm/versions/node/v20.10.0/bin:' .. vim.env.PATH
  end,
})

local CmdlineEvents = augroup('CmdlineEvents', { clear = true })
autocmd('CmdlineEnter', {
  group = CmdlineEvents,
  callback = function()
    if vim.o.cmdheight == 0 then
      vim.o.cmdheight = 1
    end
  end,
})
autocmd('CmdlineLeave', {
  group = CmdlineEvents,
  callback = function()
    if vim.o.cmdheight == 1 then
      vim.o.cmdheight = 0
    end
  end,
})
