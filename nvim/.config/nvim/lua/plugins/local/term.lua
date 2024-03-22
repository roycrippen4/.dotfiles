local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local buf_loaded = api.nvim_buf_is_loaded
local close_win = api.nvim_win_close
local create_buf = api.nvim_create_buf
local delete_buf = api.nvim_buf_delete
local get_win = api.nvim_get_current_win
local open_win = api.nvim_open_win
local send = api.nvim_chan_send
local set_win = api.nvim_set_current_win
local valid_buf = api.nvim_buf_is_valid
local win_set_buf = api.nvim_win_set_buf

local M = {}

local origin_win = nil

local terms = {
  V = {
    bufnr = nil,
    winnr = nil,
    job_id = nil,
    visible = false,
    config = {
      size = 0.4,
      resize = 'width',
      area = 'columns',
    },
  },
  H = {
    bufnr = nil,
    winnr = nil,
    job_id = nil,
    visible = false,
    config = {
      size = 0.3,
      resize = 'height',
      area = 'lines',
    },
  },
  F = {
    bufnr = nil,
    winnr = nil,
    job_id = nil,
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

    if origin_win then
      set_win(origin_win)
      origin_win = nil
    end
  end

  if term.bufnr and valid_buf(term.bufnr) and buf_loaded(term.bufnr) then
    delete_buf(term.bufnr, { force = true })
    term.bufnr = nil
  end
end

---@param term Terminal
local function term_open(term)
  term.job_id = vim.fn.termopen(vim.o.shell, {
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

    ---@diagnostic disable-next-line
    term.winnr = open_win(term.bufnr, true, term.config)
    term_open(term)
    term.visible = true
    prettify(term.winnr, term.bufnr)
    return
  end

  ---@diagnostic disable-next-line
  term.winnr = open_win(term.bufnr, true, term.config)
  term.visible = true
  prettify(term.winnr, term.bufnr)
end

---@param term Terminal
---@param direction 'F'|'H'|'V'
local function make_split(term, direction)
  assert(direction ~= 'F')

  if vim.bo.ft ~= 'terminal' then
    origin_win = get_win()
  end

  if direction == 'H' then
    origin_win = get_win()
    vim.cmd('sp')
    vim.cmd('wincmd J')
  end

  if direction == 'V' then
    vim.cmd('vsp')
    vim.cmd('wincmd L')
  end

  api['nvim_win_set_' .. term.config.resize](0, math.floor(vim.o[term.config.area] * term.config.size))
  term.winnr = get_win()
  term.visible = true
end

---@param term Terminal
---@param direction 'F'|'H'|'V'
local function show_split(term, direction)
  make_split(term, direction)
  win_set_buf(term.winnr, term.bufnr)
  prettify(term.winnr, term.bufnr)
end

---@param term Terminal
---@param direction 'F'|'H'|'V'
---@param create? boolean
local function show(term, direction, create)
  if direction == 'F' then
    show_float(term, create)
    return
  end

  if create then
    term.bufnr = create_buf(false, true)
    show_split(term, direction)
    term_open(term)
    return
  end

  show_split(term, direction)
end

---@param direction 'F'|'H'|'V'
local function toggle(direction)
  local term = terms[direction]
  if not term.bufnr then
    show(term, direction, true)
    return
  end

  if term.visible then
    close_win(term.winnr, true)
    term.winnr = nil
    term.visible = false

    if origin_win then
      set_win(origin_win)
      origin_win = nil
    end
    return
  end

  show(term, direction)
end

function M.toggle_horizontal()
  toggle('H')
end

function M.toggle_vertical()
  toggle('V')
end

function M.toggle_floating()
  toggle('F')
end

local ensure_and_send = function(cmd, type)
  if not terms[type].bufnr then
    show(terms[type], type, true)
  end

  if not terms[type].visible then
    show(terms[type], type)
  end

  send(terms[type].job_id, cmd)
  feed('<CR>', 'n')
end

---@param cmd string
---@param type 'F'|'H'|'V'
function M.send(cmd, type)
  if not cmd then
    return
  end

  ensure_and_send(cmd, type)
end

-- autoinsert when entering term buffers
autocmd({ 'BufEnter' }, {
  pattern = 'term://*',
  group = augroup('TermGroup', { clear = true }),
  callback = function()
    vim.cmd('startinsert')
  end,
})

return M
