require('base46.term')
local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local buf_loaded = api.nvim_buf_is_loaded
local close_win = api.nvim_win_close
local create_buf = api.nvim_create_buf
local delete_buf = api.nvim_buf_delete
local open_win = api.nvim_open_win
local valid_buf = api.nvim_buf_is_valid

local M = {}

local terms = {
  V = {
    bufnr = nil,
    winnr = nil,
    visible = false,
    config = {
      relative = 'editor',
      border = 'none',
      width = 100,
      height = vim.o.lines - 3,
      row = 1,
      col = vim.o.columns,
    },
  },
  H = {
    bufnr = nil,
    winnr = nil,
    visible = false,
    config = {
      relative = 'editor',
      border = 'none',
      width = 500,
      height = 20,
      col = math.floor(vim.o.columns - 0.6 / 2),
      row = 38,
    },
  },
  F = {
    bufnr = nil,
    winnr = nil,
    visible = false,
    config = {
      relative = 'editor',
      border = 'none',
      width = 150,
      height = 30,
      row = math.floor(((vim.o.lines - 30) / 2) - 1),
      col = math.floor((vim.o.columns - 150) / 2),
    },
  },
}

---@param winnr integer
---@param bufnr integer
local function prettify(winnr, bufnr)
  vim.wo[winnr].number = false
  vim.wo[winnr].cursorline = false
  vim.wo[winnr].relativenumber = false
  vim.wo[winnr].foldcolumn = '0'
  vim.wo[winnr].signcolumn = 'no'
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].ft = 'terminal'
  vim.wo[winnr].winhl = 'Normal:NormalFloat,WinSeparator:WinSeparator'
  vim.cmd('startinsert')
end

---@param term Terminal
local function close_window(term)
  if term.winnr then
    close_win(term.winnr, true)
    term.winnr = nil
    term.visible = false
  end

  if term.bufnr and valid_buf(term.bufnr) and buf_loaded(term.bufnr) then
    delete_buf(term.bufnr, { force = true })
    term.bufnr = nil
  end
end

---@param term Terminal
local function term_open(term)
  vim.fn.termopen(vim.o.shell, {
    on_exit = function()
      close_window(term)
    end,
  })
end

---@param term Terminal
---@param create? boolean
local function show_float(term, create)
  if create then
    term.bufnr = create_buf(false, true)
    term.winnr = open_win(term.bufnr, true, term.config)
    term_open(term)
    term.visible = true
    prettify(term.winnr, term.bufnr)
    return
  end

  term.winnr = open_win(term.bufnr, true, term.config)
  term.visible = true
  prettify(term.winnr, term.bufnr)
end

---@param t 'F'|'H'|'V'
function M.toggle(t)
  log(terms)
  local term = terms[t]
  if not term.bufnr then
    show_float(term, true)
    return
  end

  if term.visible then
    close_win(term.winnr, true)
    term.winnr = nil
    term.visible = false
    return
  end

  show_float(term)
end

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = 0 })
  vim.keymap.set('t', '<C-h>', [[<cmd> wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<cmd> wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<cmd> wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<cmd> wincmd l<CR>]], opts)
end

-- autoinsert when entering term buffers
autocmd({ 'BufEnter' }, {
  pattern = 'term://*',
  group = augroup('TermGroup', { clear = true }),
  callback = function()
    set_terminal_keymaps()
    vim.cmd('startinsert')
  end,
})

return M
